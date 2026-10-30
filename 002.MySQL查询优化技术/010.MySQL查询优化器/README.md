# MySQL查询优化器<sup>源码解析(基于8.0.30)</sup>
&nbsp;&nbsp;本目录基于 `001.SOURCE_CODE/001.mysql-server-8.0.30-GA/mysql-8.0.30-server` 源码，系统拆解 MySQL 查询优化器的**处理流程**、**源码结构**与**核心算法**。所有函数均标注 `文件:行号`，可直接对照源码学习。

> 优化器在整个 SQL 生命周期中的位置（详细链路见 [004.MySQL执行流程/000.一条SQL的执行全链路](../../004.MySQL执行流程/000.一条SQL的执行全链路(基于8.0.30源码).md)）：
> ```
> SQL文本 → 词法/语法解析 → [逻辑优化(Resolver)] → [物理优化(Optimizer)] → AccessPath树 → Iterator树 → 逐行执行
>           sql/sql_parse.cc    sql/sql_resolver.cc    sql/sql_optimizer.cc    join_optimizer/     sql_executor.cc     sql_union.cc:1185
>           (本目录不展开)        ← 语义变换,与代价无关 →  ← 代价搜索,决定表序/索引 →
> ```

---

## 优化器全景图

```
                    SQL: SELECT ... FROM t1 JOIN t2 ON ... WHERE ...
                                      │
        ┌─────────────────────────────▼──────────────────────────────┐
        │ ① 解析 (sql/sql_parse.cc)                                    │
        │    dispatch_command(:1610) → dispatch_sql_command(:5111)     │
        │    → parse_sql(:5135) 产出 LEX + Query_block AST             │
        └─────────────────────────────┬──────────────────────────────┘
                                      ▼
        ┌────────────────────────────────────────────────────────────┐
        │ ② 逻辑优化: Query_block::prepare (sql/sql_resolver.cc:173)   │
        │    语义分析(fix_fields) → 视图/派生表合并(merge_derived:3416) │
        │    → 子查询改写(resolve_subquery:1342 / flatten_subqueries:  │
        │    3760: semi-join化 / IN→EXISTS) → 外连接转内连接           │
        │    (simplify_joins:1880) → 条件下推到派生表(:597)            │
        │    ※ 规则驱动,不算成本,改写的是"查询的结构"                   │
        └─────────────────────────────┬──────────────────────────────┘
                                      ▼
        ┌────────────────────────────────────────────────────────────┐
        │ ③ 物理优化: JOIN::optimize (sql/sql_optimizer.cc:281)        │
        │    A.条件化简 optimize_cond(:415) / 分区裁剪(:443) /          │
        │      MIN/MAX常量化(:458)                                      │
        │    C.成本搜索 make_join_plan(:5168):                          │
        │      常量表检测(extract_const_tables:5484)                    │
        │      → range分析(test_quick_select, range_optimizer.cc:523)  │
        │      → 连接顺序搜索 choose_table_order(sql_planner.cc:1945)  │
        │        (贪心+深度受限穷举, best_access_path:980选访问路径)      │
        │      → get_best_combination(:2967) 定稿表序                   │
        │    D.连接序后优化: 条件分配(make_join_query_block:9319)、      │
        │      排序消除(optimize_distinct_group_order:1400)            │
        │    E.计划落地: make_join_readinfo(sql_select.cc:3071,含ICP)、 │
        │      make_tmp_tables_info(sql_select.cc:4139)、              │
        │      create_access_paths(sql_executor.cc:2904) → AccessPath  │
        │    ※ 代价驱动,决定"每个表怎么读、按什么顺序连"                 │
        └─────────────────────────────┬──────────────────────────────┘
                                      ▼
        ┌────────────────────────────────────────────────────────────┐
        │ ④ 计划物化 + 执行                                             │
        │    Query_expression::optimize (sql_union.cc:676) 末尾        │
        │    → CreateIteratorFromAccessPath (join_optimizer/          │
        │      access_path.cc:333) 生成 Iterator 树                    │
        │    → ExecuteIteratorQuery (sql_union.cc:1185) Init/Read 驱动 │
        └────────────────────────────────────────────────────────────┘

  另一条路(8.0.30 默认关闭): Hypergraph 新优化器
    JOIN::optimize :551 分支 → MakeJoinHypergraph(join_optimizer/
    make_join_hypergraph.cc:3131) → DPhyp 动态规划搜索 FindBestQueryPlan
    (join_optimizer.cc:5834) —— 开关 optimizer_switch=hypergraph_optimizer=on
```

---

## 文档目录

| 篇目 | 内容 | 关键源码 |
|---|---|---|
| [01.优化器处理流程总览](./01.优化器处理流程总览.md) | 从 `dispatch_command` 到 `ExecuteIteratorQuery` 的完整调用链；首次执行 vs Prepared Statement 重复执行；一张总流程图 | sql_parse.cc / sql_select.cc / sql_union.cc |
| [02.逻辑优化源码解析(Prepare阶段)](./02.逻辑优化源码解析-Prepare阶段.md) | `Query_block::prepare` 28 个步骤；视图/派生表合并 vs 物化；外连接转内连接；条件下推到派生表 | sql_resolver.cc |
| [03.子查询优化源码解析](./03.子查询优化源码解析.md) | 子查询策略矩阵；IN→EXISTS 注入了什么条件；semi-join 化与 5 种执行策略；子查询物化 | sql_resolver.cc / item_subselect.cc / sql_planner.cc |
| [04.物理优化源码解析(JOIN之optimize)](./04.物理优化源码解析-JOIN之optimize.md) | `JOIN::optimize` 五大阶段(A逻辑改写/C成本搜索/D连接序后/E计划落地)；常量表检测与读取；条件分配；临时表管线 | sql_optimizer.cc |
| [05.连接顺序搜索与访问路径选择源码解析](./05.连接顺序搜索与访问路径选择源码解析.md) | 贪心+深度受限穷举混合算法；`best_access_path` 候选与决策序；剪枝参数；hash join 在哪生成；semi-join 策略选择 | sql_planner.cc |
| [06.Range优化器源码解析](./06.Range优化器源码解析.md) | `test_quick_select` 12 步；WHERE→SEL_TREE/SEL_ARG 区间树；index dive vs 索引统计；ICP/MRR 触发点 | range_optimizer/ |
| [07.成本模型源码解析](./07.成本模型源码解析.md) | `Cost_model_server` 接口；成本常量默认值与 mysql.server_cost/engine_cost 表；handler 层成本上报；FLUSH OPTIMIZER_COSTS | opt_costconstants.cc / opt_costmodel.cc / handler.h |
| [08.Hypergraph新优化器与迭代器执行器](./08.Hypergraph新优化器与迭代器执行器.md) | join_optimizer/ 目录与 DPhyp 算法；图简化；Iterator 执行器类体系与执行循环 | sql/join_optimizer/ / sql/iterators/ |
| [09.优化器如何决定用哪个索引](./09.优化器如何决定用哪个索引.md) | **综合篇**：索引选择的五级漏斗（候选集→range初估→连接比价→排序偏好→计划修正）；possible_keys 的位图来源；FORCE INDEX 三个生效点；排障速查表 | table.cc / sql_planner.cc / range_optimizer/ |
| [10.实战案例-IN列表超过200导致主键计划翻转](./10.实战案例-IN列表超过200导致主键计划翻转.md) | **实战篇（脱敏）**：`eq_range_index_dive_limit` 边界实验定位法；大 IN 导致主键计划翻转到二级索引倒序全扫；FORCE INDEX(PRIMARY) 修复与可证性论证 | sys_vars.cc:3877 / index_range_scan_plan.cc / sql_planner.cc |

---

## ⚠️ 8.0.30 源码命名对照表（先看这个，少走弯路）

&nbsp;&nbsp;网上大量资料基于 5.7 或早期 8.0，很多函数名在本源码树中**已经改名或重构**（全部经 grep 验证）。读资料时按下表换算：

| 旧名称（资料常见） | 8.0.30 实际 | 位置 |
|---|---|---|
| `make_join_statistics` | `JOIN::make_join_plan` | sql/sql_optimizer.cc:5168 |
| `make_join_select` | `make_join_query_block`（static） | sql/sql_optimizer.cc:9319 |
| `JOIN::choose_plan` | `Optimize_table_order::choose_table_order` | sql/sql_planner.cc:1945 |
| `QUICK_SELECT_I`/`QUICK_RANGE_SELECT` 等 QUICK 类族 | 计划期 `AccessPath` + 执行期 `RowIterator`（见 [06 篇](./06.Range优化器源码解析.md)映射表） | join_optimizer/access_path.h:188 |
| `opt_range.cc`（range 主文件） | 已拆分为 `range_optimizer.cc`（入口）/`range_analysis.cc`（条件→区间）/`tree.cc`（SEL_ARG） | sql/range_optimizer/ |
| `SEL_ARG::get_next()` | `SEL_ROOT::find_range`(:161) + next/prev 双向链表(tree.h:516) | sql/range_optimizer/tree.h |
| `Engine_cost_constants` | `SE_cost_constants` | sql/opt_costconstants.h:196 |
| `subquery_allows_materialization`（旧资料的"物化成本对比入口"） | 仍存在：`Item_in_subselect::subquery_allows_materialization`（sql/sql_resolver.cc:964），由 `JOIN::decide_subquery_strategy`（sql_optimizer.cc:10793，调用点 :10886）判断物化可行性；最终改写在 `finalize_materialization_transform`（item_subselect.cc:438） | sql_resolver.cc:964 / item_subselect.cc:438 |
| `rewrite_to_index_subquery_engine` | 已移除（迭代器模型下无此重写） | — |
| `fix_semijoin_strategies`（部分资料误为 get_best_combination 职能） | `Optimize_table_order::fix_semijoin_strategies`(:3365) + `JOIN::get_best_combination`(:2967) | sql_planner.cc / sql_optimizer.cc |
| `JOIN::create_iterators` | 不存在；由 `Query_expression::optimize` 调 `CreateIteratorFromAccessPath` | sql/sql_union.cc:833 |
| BNL(Block Nested Loop) | 规划期仍叫 BNL，执行器期被**无条件替换**为 hash join | sql/sql_executor.cc:2676 |

---

## 核心数据结构速查

| 结构 | 定义位置 | 作用 |
|---|---|---|
| `LEX` | sql/sql_lex.h | 解析产物，持有 `m_sql_cmd` |
| `Sql_cmd_dml` | sql/sql_cmd_dml.h | DML 命令对象，`execute()` 是 DML 总入口（实现 sql_select.cc:490） |
| `Query_expression`(unit) | sql/sql_lex.h | 一条查询表达式（UNION 的整体） |
| `Query_block` | sql/sql_lex.h | 一个 SELECT 块；`prepare`(resolver)/`optimize`(select.cc:1803) |
| `JOIN` | sql/sql_optimizer.h:125 | 单个 query_block 的优化上下文与计划载体 |
| `JOIN_TAB` / `QEP_TAB` | sql_optimizer.h:146 / sql_executor.h:259 | 规划期表槽位 / 执行计划表槽位（含临时表） |
| `POSITION` | sql/sql_select.h:351 | 搜索过程中的前缀状态（成本/行数/访问方式/sj策略），POD 可 memcpy |
| `Key_use` | sql/sql_optimizer.h | ref 访问候选（哪个索引哪个 keypart 绑什么值） |
| `SEL_TREE`/`SEL_ARG`/`SEL_ROOT` | range_optimizer/tree.h:870/464/67 | WHERE 条件翻译成的索引区间树 |
| `AccessPath` | sql/join_optimizer/access_path.h:188 | 计划树节点（8.0 统一计划表示） |
| `RowIterator` | sql/iterators/row_iterator.h:81 | 执行器迭代器基类，`Read()` 产出一行 |

---

## 与本目录其他笔记的关系

- 各优化技术专题（覆盖索引/ICP/MRR/索引合并/Skip Scan……）见[上级目录](../README.md)；本目录回答"这些技术是**优化器哪段代码在什么条件下选出来的**"
- 为什么优化器不用某个索引：[008.优化器选择不使用索引的情况](../008.优化器选择不使用索引的情况.md)（成本根源在 [07 篇](./07.成本模型源码解析.md)）
- 索引提示（USE/FORCE INDEX、JOIN_ORDER hint）如何干预优化器：[007.索引提示](../007.索引提示.md)（生效点在各篇有标注：FORCE INDEX → `test_quick_select` 的 `ignore_table_scan` 参数 range_optimizer.cc:549；JOIN_ORDER hint → `apply_join_order_hints` 调用点 sql_optimizer.cc:5240）
