# MySQL查询优化与调优工具集·总结

> 一些小总结，相当于目录,默认来自于5.7文档，其他内容来自于标记的版本.

> 2026-10-25 增补「优化原理 × 适用场景」总纲（本文件其余小节），原导语保留。18 篇笔记原文一律未改动；本文件只做分析、归纳与导航。
> 源码锚点根路径：`001.SOURCE_CODE/001.mysql-server-8.0.30-GA/mysql-8.0.30-server/`，下文 `sql/`、`storage/innobase/` 均相对此根目录，**行号均已逐一核实**。
> 手册章节号依据 `007.参考资料/refman-8.1-en.pdf` 书签核实（见文末参考对照）。

---

## 一、文档地图

| 文件 | 主题 | 手册章节(8.1) | 底本版本 |
|---|---|---|---|
| 001.MySQL查询优化之explain.md | EXPLAIN 输出全解（id/type/key/rows/filtered/Extra、访问类型、EXPLAIN ANALYZE） | 8.2.1 概览 | 8.0 文档为主，含 5.7.35 实操 |
| 002.MySQL之WHERE子句优化.md | WHERE 的 9 项自动优化清单 | 8.2.1.1 | 5.7 |
| 003.Range_Optimization.md | Range 优化器（区间构造、IN 等值、index dive、Skip Scan） | 8.2.1.2 | 5.7 + 8.0.13 Skip Scan 小节 |
| 004.Engine Condition Pushdown Optimization.md | ECP 引擎条件下推（NDB 专属） | 8.2.1.5 | 5.7 |
| 005.Index Condition Pushdown Optimization.md | ICP 索引条件下推 | 8.2.1.6 | 5.7 |
| 006.Nested-Loop Join Algorithms.md | NLJ 与 BNL 算法 | 8.2.1.7 | 8.0 |
| 008.Nested Join Optimization.md | 嵌套连接语法（括号表列表、CROSS JOIN ≡ INNER JOIN） | 8.2.1.8 | 8.0 |
| 009.Hash Join Optimization.md | Hash Join（8.0.18+） | 8.2.1.4 | 8.0，8.0.30 实测 |
| 010.Outer Join Optimization.md | 外连接执行顺序与外连接→内连接转换 | 8.2.1.9 / 8.2.1.10 | 5.7 |
| 012.Block Nested-Loop and Batched Key Access Joins.md | BNL buffer 管理 与 BKA+MRR | 8.2.1.12 | 5.7 |
| 013.Condition Filtering.md | Condition Filtering（filtered 与 join 顺序） | 8.2.1.13 | 5.7 语义 |
| 014.Constant-Folding Optimization.md | 常量与列比较的优化期折叠 | 8.2.1.14 | **MySQL 8.0+**（笔记明确标注） |
| 015.IS NULL Optimization.md | IS NULL 的索引优化（ref_or_null） | 8.2.1.15 | 5.7 语义 |
| 016.ORDER BY Optimization.md | 索引序消排序、filesort 三种元组格式 | 8.2.1.16 | 8.2 手册底本 |
| 017.GROUP BY Optimization.md | 松散/紧凑索引扫描、临时表三途径 | 8.2.1.17 | 8.2 手册底本，5.7/8.0.30 双版实测 |
| 018.MySQL-The Optimizer Trace.md | Optimizer Trace 开发文档翻译（三阶段、offset/limit） | —（内部文档） | **8.0.30**（含源码函数引用） |
| 019.DISTINCT Optimization.md | DISTINCT ≡ GROUP BY 及联合优化 | 8.2.1.18 | 8.2 手册底本 |

说明：目录编号存在缺号（007、011 无文件），保留原状。`REF_Docs/` 内存放 018 号笔记配套的《The Optimizer Trace》PDF。

---

## 二、优化总纲：一条 SQL 是如何被优化的（基于 8.0.30 源码）

MySQL 查询优化分两个阶段：**逻辑优化**（改写查询，与代价无关，永远合算）→ **物理优化**（基于代价挑访问路径与 join 顺序）。之后进入执行器。所有优化发生在 **Server 层**，InnoDB 只提供"给我区间/给我行"的接口——跨层边界上的动作（逐行传输、回表、Server 物化）才是优化的标靶。

```
SQL
 │
 ▼
Server 层  dispatch_command (sql_parse.cc:1610)
 │            │ 解析/消解
 │            ▼
 │ ┌────── 逻辑优化（改写 SQL，代价无关）──────────────────────────┐
 │ │ 外连接→内连接转换  Query_block::simplify_joins              │
 │ │                    (sql_resolver.cc:1880)      → 笔记 010   │
 │ │ 条件化简/等式传播   optimize_cond                              │
 │ │   （trace 中 condition_processing 各步）                       │
 │ │                    (sql_optimizer.cc:10062)    → 笔记 002/015 │
 │ │ 常量折叠            fold_condition (8.0.14+)                   │
 │ │                    (sql_const_folding.cc:1254) → 笔记 014     │
 │ │ 常量表判定          JOIN::extract_const_tables                 │
 │ │                    (sql_optimizer.cc:5484)     → 笔记 002    │
 │ └──────────────────────────────────────────────────────────────┘
 │            ▼
 │ ┌────── 物理优化（基于代价）───────────────────────────────────┐
 │ │ 计划入口  JOIN::optimize (sql_optimizer.cc:281)              │
 │ │           JOIN::make_join_plan (sql_optimizer.cc:5168)       │
 │ │ Range 优化器 test_quick_select                               │
 │ │           (sql/range_optimizer/range_optimizer.cc:523)       │
 │ │   ├ Skip Scan      get_best_skip_scan                        │
 │ │   │                (range_optimizer/index_skip_scan_plan.cc:165) → 笔记 003 │
 │ │   └ 松散索引扫描    get_best_group_min_max                    │
 │ │                    (range_optimizer/group_index_skip_scan_plan.cc:286) → 笔记 017 │
 │ │ join 顺序  Optimize_table_order::choose_table_order          │
 │ │           (sql_planner.cc:1945)  ← Condition Filtering 供行数 → 笔记 013 │
 │ │ 访问路径  best_access_path (sql_planner.cc:980)              │
 │ │   ├ 索引序消排序  test_if_order_by_key (sql_optimizer.cc:1735) → 笔记 016 │
 │ │   └ 行数估算      ha_innobase::records_in_range (ha_innodb.cc:16649)      │
 │ └──────────────────────────────────────────────────────────────┘
 │            ▼
 │ ┌────── 执行（迭代器流水线，AccessPath 驱动）──────────────────┐
 │ │ filesort (filesort.cc:366)                    → 笔记 016     │
 │ │ HashJoinIterator（hash_join_iterator.cc:111 建哈希表） → 009 │
 │ │ BKAJoinIterator（bka_iterator.cc，批量走 MRR）         → 012 │
 │ │ ICP：idx_cond_push (sql/handler.h:5821)                       │
 │ │      → innobase_index_cond (ha_innodb.cc:23419)               │
 │ │      → row_search_idx_cond_check (row0sel.cc:3731)    → 005  │
 │ │ MRR：DsMrr_impl::dsmrr_init (sql/handler.cc:6406)     → 012  │
 │ └──────────────────────────────────────────────────────────────┘
 ▼
存储引擎层（InnoDB：索引/回表/Buffer Pool）
```

### 为什么有效：分层架构下的四类杠杆

| 杠杆 | 减少的开销 | 对应优化 |
|---|---|---|
| 少读数据 | 索引/表的访问量 | Range、Skip Scan、松散索引扫描、覆盖索引 |
| 少跨层传行 | Server↔引擎逐行交互、回表 | ICP、ICP 变体 ref_or_null、ECP（NDB 省网络）、MRR/BKA（省随机 I/O） |
| 少 Server 物化 | 排序/临时表 | 索引序消 filesort、GROUP BY 索引途径、DISTINCT 转分组 |
| 让优化器多选 | 劣质计划 | 逻辑改写（外连接转内连接后表序可调）、统计信息/直方图 |

> 互通：分层架构与"跨层三个昂贵动作"的总纲见 `../002.MySQL查询优化技术/README.md`；SQL 执行全链路（优化器在其中的位置）见 `../004.MySQL执行流程/README.md`。

---

## 三、逐主题整理：优化原理 × 适用场景

### 3.1 调优工具链（001 / 018）

**原理**：EXPLAIN 是优化器决策的只读投影——`type` 列就是 `best_access_path` 选出的访问方法，`rows` 来自引擎行数估算，`filtered` 来自 Condition Filtering（见 3.3）。EXPLAIN 生成入口 `explain_query_specification`（sql/opt_explain.cc:1938）。Optimizer Trace 则把优化过程本身写进 JSON：`Opt_trace_context::start`（sql/opt_trace.cc:827），分 `join_preparation`（expanded_query）→ `join_optimization`（condition_processing / rows_estimation 与 range_analysis / considered_execution_plans 与 best_access_path / refine_plan）→ `join_execution` 三阶段。

**适用场景**：

- 日常诊断：EXPLAIN 看 type/key/rows/Extra，回答"计划是什么、快不快"。
- 8.0.18+：`EXPLAIN ANALYZE`（FORMAT=TREE）给出**实际执行**计时，验证估算与现实的偏差。
- 计划不符合预期时：Optimizer Trace 回答"**为什么这么选**"——对比 `analyzing_range_alternatives` 中各访问路径 cost 与 `chosen/cause` 字段。SELECT 与 EXPLAIN SELECT 产生相同 trace（IN 子查询例外）。

**限制（001 笔记整理）**：不反映触发器/存储过程/UDF 影响；filesort 与 Using temporary 不区分内存/磁盘；小 LIMIT 可能误显示全索引扫描；FROM 子查询会被实际执行。Trace 有内存/性能开销，新 trace 覆盖旧的，用 `optimizer_trace_offset=-1, limit=1` 取最后一条。

### 3.2 逻辑优化：改写查询本身（002 / 014 / 015 / 010）

**原理**：这一类优化不依赖代价，条件满足就做，属于 `optimize_cond`（sql_optimizer.cc:10062）与 `simplify_joins`（sql/sql_resolver.cc:1880）驱动的改写。trace 中对应 `condition_processing` 的 equality / constant_propagation / trivial_condition_removal / substitute_generated_columns 各步。

| 优化 | 原理 | 适用场景 / 失效条件 |
|---|---|---|
| WHERE 9 项自动优化（002） | 删多余括号、常量折叠传播、恒真恒假去除、常量表最先读（`extract_const_tables`，sql_optimizer.cc:5484）、HAVING 并入 WHERE 等 | 无需手工改写即可获得；SELECT/UPDATE/DELETE 通用 |
| 常量折叠（014，**8.0.14+**） | 常量与列比较在优化期一次性求值：越界→`WHERE 1` 或 `IS NOT NULL`，边界值→`=`；入口 `fold_condition`（sql/sql_const_folding.cc:1254） | 支持 >、>=、<、<=、=、<>、<=>；**不支持 BETWEEN/IN、BIT、日期时间**；预处理语句在执行期才生效 |
| IS NULL 优化（015） | `col IS NULL` 与 `col = 常量` 同等对待；`col=expr OR col IS NULL` 走 **ref_or_null**（先按引用键读一次，再单独搜 NULL 行） | NOT NULL 列的 IS NULL 条件被直接删除；限制：每个 key part 只能处理一个 IS NULL 层级 |
| 外连接→内连接（010） | WHERE 对 NULL 扩展行恒假（如 `WHERE t2.col=5`）时安全转换，转换后优化器可自由重排表序；由 `simplify_joins` 完成 | 依赖 WHERE 而非 ON 条件判定；STRAIGHT_JOIN 会禁用 semijoin 转换，慎用 |

### 3.3 代价估算与统计（013 + 003 的 dive）

**Condition Filtering（013）**：把访问方法没"用掉"的 WHERE 条件折算进 `filtered`，前缀行数 = rows × filtered，直接影响 join 顺序（低前缀行数的表靠前）。开关 `condition_fanout_filter`（默认 on）。
**适用**：多表 join 时让优化器看见非索引条件的过滤力。**失效对策**（笔记原文归纳）：过滤被高估变慢时——给列建索引、生成直方图、hint/STRAIGHT_JOIN 固定顺序、按查询 `SET_VAR` 关闭该开关。

**index dive vs 索引统计（003）**：IN() 等值区间的行数估算有两条路——dive（每区间两端各做一次 B+树下探，准但值多时慢）与索引统计（快但欠准）。`eq_range_index_dive_limit`（8.0.30 默认 200，sql/sys_vars.cc:3878）控制切换：等值区间数 ≥ 该值即改用统计，0 表示永远 dive。
**适用**：rows 估算严重失真时优先 `ANALYZE TABLE`，再考虑调此参数（如查询里 IN 列表超大且统计偏差大）。

### 3.4 访问路径：Range 与 Skip Scan（003 / 015 / 017 衔接）

**原理**：Range 优化器（`test_quick_select`，sql/range_optimizer/range_optimizer.cc:523）把 WHERE 逐索引抽成区间：不可用条件替换为 TRUE → 折叠恒真/恒假 → 删除空区间 → 合并重叠区间。结果比原 WHERE **宽松**，故命中后仍需用完整 WHERE 过滤。

**关键规则（003 笔记整理）**：

- BTREE 支持 =、<=>、IN、IS [NOT] NULL、>、<、>=、<=、BETWEEN、!=、LIKE '非通配开头'；HASH 只支持 =、<=>、IS NULL、IN，且多列 HASH 要求条件覆盖**全部** key part。
- 多列 BTREE：=、<=>、IS NULL 可把区间继续向右推进；>、<、>=、<=、!=、BETWEEN、LIKE **用后即停**（后面的 key part 用不上）。
- 空间索引不支持多范围合并，需改写 UNION。
- 内存保护：`range_optimizer_max_mem_size`（8.0.30 默认 8MB，sql/sys_vars.cc:3299），超限放弃 range 回退全表扫描并告警 3170。

**Skip Scan（8.0.13+）**：复合索引前缀列不在 WHERE 中时，对前缀每个不同值构造子区间扫描（类似 Loose Index Scan）；入口 `get_best_skip_scan`（range_optimizer/index_skip_scan_plan.cc:165）。适用 8 项条件（003 笔记）：单表、查询只引用索引列、前缀外列非空、前缀上常量等值（含 IN）、C 列有 range 条件等；EXPLAIN 显示 `Using index for skip scan`。

**适用场景**：WHERE 能构造出区间就用；失效典型——跳过前缀列（无 skip scan 时）、HASH 索引区间不完整、区间构造内存超限。trace 中看 `rows_estimation` → `range_analysis` → `analyzing_range_alternatives`。

### 3.5 条件下推：ICP 与 ECP（005 / 004）

| | ICP（005） | ECP（004） |
|---|---|---|
| 下推什么 | **索引列**可判定的条件 | **非索引列**与常量的直接比较 |
| 发生在哪 | 引擎层，回表**之前**用索引条目先判 | NDB 数据节点（省网络传输，提速 5~10 倍） |
| Server↔引擎接口 | `idx_cond_push`（sql/handler.h:5821）→ InnoDB 实现 `innobase_index_cond`（ha_innodb.cc:23419）→ 行级判定 `row_search_idx_cond_check`（row0sel.cc:3731） | `cond_push`（sql/handler.h:5791）；**InnoDB 未实现，仅 NDB** |
| 减少的开销 | ① 引擎回表次数 ② server 访问引擎的次数 | 数据节点 → SQL 节点的无关行网络传输 |
| EXPLAIN 特征 | `Using index condition` | `Using where with pushed condition` |
| 适用 | type 为 range/ref/eq_ref/ref_or_null 且需读整行时 | NDB 表；仅列-常量直接比较（`b+1=10` 不行，改写 `b=9` 可以） |
| 失效 | 子查询/存储函数/触发条件不下推；虚拟生成列二级索引不支持；**InnoDB 仅二级索引**（聚簇索引整行已在手，无 I/O 可省） | BLOB/TEXT/JSON/BIT/ENUM 列；跨 collation 字符串 |

分层解释：ICP 省的是"回表"这一跨层动作——条件在引擎层（row0sel.cc 取行循环内）提前判掉，不合格的行根本不产生回表；ECP 在 NDB 架构下把过滤搬到数据所在的节点，省的是网络。

### 3.6 Join 算法演进：NLJ → BNL/BKA → Hash Join（008 / 006 / 012 / 009）

```
Simple NLJ（5.x 基线）      外表逐行传给内层循环，内表被反复全读
   │  引入 join buffer
   ▼
BNL（5.7 / ≤8.0.19）        buffer 缓存外表连接列，内表每行与 buffer 全组比较
                            内表扫描次数 ≈ (S·C)/join_buffer_size + 1
   │  8.0.18 引入 hash join；8.0.20 移除 BNL
   ▼
Hash Join（8.0.18+）        内表建哈希表、外表探测（009 实测 EXPLAIN FORMAT=TREE）
BKA（独立线，8.0 仍保留）    内表有索引：buffer 攒批 key → MRR 有序取数
```

- 8.0.30 源码佐证：BNL 的 `JOIN_CACHE_BNL` 类已删除，仅存注释说明"BNL 由执行器中的 hash join 替代"（sql_optimizer.cc:3282-3288）；join buffer 基类仍在 sql/sql_join_buffer.h:68。Hash Join 实现在 sql/iterators/hash_join_iterator.cc（`HashJoinIterator::InitRowBuffer`:111 建表阶段，超出 `join_buffer_size` 溢写磁盘 chunk）；BKA 实现在 sql/iterators/bka_iterator.cc（开关 `batched_key_access`，sql/sys_vars.cc:3409）。
- BKA（012 笔记，5.7 视角）：需 `batched_key_access=on` 且 `mrr=on`、`mrr_cost_based=off`（MRR 代价估计过于悲观）；EXPLAIN 特征 `Using join buffer (Batched Key Access)`，type 为 ref/eq_ref。

**适用场景矩阵**：

| 场景 | 5.7 | 8.0.18~8.0.19 | 8.0.20+ |
|---|---|---|---|
| 内表有索引，等值 | ref/eq_ref（可 BKA 提效） | 同左 | 同左（BKA 保留） |
| 内表无索引，等值 | BNL | Hash Join | Hash Join |
| 内表无索引，非等值/笛卡尔积 | BNL | 仍走 BNL | **Hash Join**（8.0.20 起不再要求等值条件） |
| 外连接/半连接/反连接 | BNL 扩展（match flag） | Hash Join | Hash Join（antijoin 计划自 8.0.17 可见） |

通用心法（006 笔记"思考"）：小表驱动大表——外表行数决定 buffer 组数与内存，内表扫描次数由 buffer 大小摊薄。

语法基础（008）：括号表列表 `t1 LEFT JOIN (t2,t3,t4) ON...` 等价于对 t2/t3/t4 依次 INNER JOIN；MySQL 中 CROSS JOIN 与 INNER JOIN 完全等价（标准 SQL 不等价）。外连接语义与转换（010）见 3.2。

### 3.7 排序、分组与去重（016 / 017 / 019）

**ORDER BY（016）**：

- 走索引的条件：不必完全匹配索引——索引未使用部分及额外排序列在 WHERE 中均为**常量**即可（如 `WHERE key_part1=const ORDER BY key_part2`）；判定入口 `test_if_order_by_key`（sql_optimizer.cc:1735）。InnoDB 二级索引尾部隐含主键，也是排序可用资源。
- 不可用索引的典型情形（016 枚举）：跨不同索引排序、表达式排序（ABS(key)、-key）、连接时排序列不全来自第一个非常量表、ORDER BY 与 GROUP BY 表达式不同、前缀索引、HASH 索引。
- 退化到 filesort（filesort.cc:366）后按元组格式分三种：`<sort_key, rowid>`（排完回表）、`<sort_key, additional_fields>`、`<sort_key, packed_additional_fields>`（016 笔记）。**版本差异（本次核实）**：三种模式在 8.0.30 仍存在，由 `Sort_param::decide_addon_fields`（sql/filesort.cc:161）选择，但决定阈值不再是 `max_length_for_sort_data`——该变量在 8.0.30 已 deprecated 且无效（sql/sys_vars.cc:3036 描述"deprecated and will be removed"；sql/system_variables.h:219 注释 `Unused`）；8.0.30 trace 中 sort_mode 第一段实际是 `fixed_sort_key`/`varlen_sort_key`（filesort.cc:577-587）。
- DESC：全同向（全 ASC/全 DESC）可直接反向扫索引；**混合方向**需降序索引（8.0 特性）。
- 别名三条规则（016）：`ORDER BY a` 引用真实列可用索引；引用表达式别名的不可用。
- trace 观察点：`filesort_summary`（rows/examined_rows/number_of_tmp_files/peak_memory_used/sort_mode）与 `filesort_priority_queue_optimization`。

**GROUP BY（017）**：三条途径，按效率排序：

1. **松散索引扫描**（Loose Index Scan）：只读每组第一个键；入口 `get_best_group_min_max`（range_optimizer/group_index_skip_scan_plan.cc:286）。条件：单表、GROUP BY 列为索引**最左前缀**、索引其余部分为常量等式（gap 必须补齐）、全列索引非前缀索引。函数形式限制：① 仅 MIN()/MAX() 指向紧跟 GROUP BY 列之后的同一列；② AVG(DISTINCT)/SUM(DISTINCT)（单参数）、COUNT(DISTINCT)（可多列），且**无 GROUP BY、无 DISTINCT 子句**时。
2. **紧凑索引扫描**（Tight Index Scan）：gap 用常量等式填补后走完整前缀的 range/ref 扫描（如 `WHERE c2='a' GROUP BY c1,c3`）。
3. **临时表**：无索引可用时的兜底，EXPLAIN 显示 `Using temporary`。

**DISTINCT（019）**：`SELECT DISTINCT c1,c2,c3` ≡ `GROUP BY c1,c2,c3`，GROUP BY 的索引优化全部适用；与 LIMIT 联用凑够行数即停；多表连接中未用到某表的列时该表读到第一条匹配即停。Server 层入口 `JOIN::optimize_distinct_group_order`（sql_optimizer.cc:1400）。017 笔记实测补充：8.0 中 COUNT(DISTINCT) 还能看到 "Covering index skip scan for deduplication"（跳扫去重）。

**版本差异（016 笔记标注）**：8.1 及以下 GROUP BY 隐式排序，8.2 起移除——不要再依赖隐式排序，也不要习惯性补 `ORDER BY NULL`。

---

## 四、DBA 排错对照表

| 症状 / EXPLAIN 特征 | 优先工具 | 看什么 | 常见根因 | 对应笔记 |
|---|---|---|---|---|
| type=ALL 全表扫 | EXPLAIN | possible_keys/key/Extra | 无索引、列上套函数、隐式类型转换 | 001/003 |
| Using filesort，排序慢 | EXPLAIN + trace | filesort_summary 的 number_of_tmp_files、peak_memory_used | ORDER BY 无可用索引、混合升降序、表达式排序 | 016 |
| Using temporary | EXPLAIN | GROUP BY/ORDER BY 列与索引关系 | GROUP BY 非最左前缀、与 ORDER BY 不一致、DISTINCT 联用 | 017/019 |
| rows 估算巨大但实际行少 | EXPLAIN ANALYZE + trace | rows_estimation 中 dive 与统计的取舍 | 统计陈旧、IN 值多走索引统计 | 003（`ANALYZE TABLE` / eq_range_index_dive_limit） |
| 优化器没走预期索引 | trace | considered_execution_plans、best_access_path 的 cost 与 cause | 代价估算偏差、filtered 高估 | 018/013（hint、直方图） |
| Using join buffer (Block Nested Loop) | EXPLAIN | join 列有无索引 | 无索引等值 join；**8.0.20+ 该标志已消失（改 hash join），看到即版本 <8.0.20** | 006/009 |
| 预期 ICP 但无 Using index condition | EXPLAIN + trace | 条件构成、访问类型 | 条件含子查询/存储函数、虚拟生成列索引、聚簇索引 | 005 |
| type=ref/eq_ref 但 join 慢 | EXPLAIN | BKA/MRR 是否启用 | `batched_key_access`/`mrr` 未开、MRR 代价悲观 | 012 |
| join 顺序劣、filtered 异常 | trace | attaching_conditions_to_tables 后的 filtered | condition_fanout_filter 高估过滤力 | 013（直方图/hint/关开关） |
| range 没生效且告警 3170 | SHOW WARNINGS | range_optimizer_max_mem_size | 区间构造内存超 8MB 回退全表扫 | 003 |

---

## 五、版本演进备忘（5.7 → 8.0 → 8.2）

| 版本 | 变化 | 出处 |
|---|---|---|
| 5.7 | BNL/BKA 体系完整（012 为其文档）；WHERE/外连接/IS NULL 等笔记底本 | 002/004/005/010/012 |
| 8.0.13 | Skip Scan 引入 | 003 标注 |
| 8.0.14 | 常量折叠（014 标注 MySQL8+，5.7 无此优化） | 014 |
| 8.0.17 | EXPLAIN 可见 antijoin | 001 标注 |
| 8.0.18 | Hash Join 引入（仅等值）；EXPLAIN ANALYZE / FORMAT=TREE | 009/001 |
| 8.0.20 | BNL 移除；Hash Join 覆盖非等值、笛卡尔积、外连接；不再要求等值条件 | 009/006；8.0.30 源码已无 JOIN_CACHE_BNL 类 |
| 8.0.27 | FORMAT=TREE 显示覆盖索引信息 | 001 标注 |
| 8.0.30 | range 优化器源码位于 sql/range_optimizer/（tree.cc、range_analysis.cc、index_skip_scan_plan.cc、group_index_skip_scan_plan.cc 等）；BNL/旧 JOIN_CACHE_BKA 类已删；执行器为 AccessPath+迭代器（hash_join_iterator.cc、bka_iterator.cc）；`max_length_for_sort_data` deprecated 无效 | 本次源码核实 |
| 8.2 | 013/014/015/016/017/019 笔记引用 8.2 手册；GROUP BY 隐式排序：8.0.13（WL#8693）起官方即宣布不可依赖，8.2 手册的"8.1 及以下隐式排序、8.2 不再发生"是随版本滚动的表述——实务上一律显式 ORDER BY | 016 标注 + 官方博客/WL 核实 |
| 全版本 | ECP 仅 NDB 支持，InnoDB 不实现 `cond_push`；8.0 文档中该节已并入 NDB 章节 | 004 + handler.h:5791 核实 |

---

## 六、阅读顺序建议与互通

建议主线：001（看懂计划）→ 002/014/015/010（逻辑改写）→ 003（range 与 skip scan）→ 013（filtered 与表序）→ 005/004（条件下推）→ 008/006/012/009（join 演进线）→ 016/017/019（排序分组去重）→ 018（进阶：读 trace 精确定位优化器决策）。

> 互通: `../002.MySQL查询优化技术/`——延迟关联、覆盖索引等优化技术的「优化原理（源码视角，基于 8.0.30）」与「架构视角」小节，与本目录互为"技术侧 ↔ 工具与算法侧"。
> 互通: `../004.MySQL执行流程/README.md`——一条 SQL 的执行全链路，优化器三阶段在链路中的位置。
> 互通: `../003.MySQL事务/`——隔离级别与 MVCC 对执行计划中一致性读行为的影响。

## 七、修订记录（2026-10-25 第二轮：错误修复 + 各篇源码对照增补）

18 篇笔记原文一律保留，仅做勘误与文末追加「优化原理与源码对照（基于 8.0.30）」小节（含 ASCII 流程图与已核实行号）。主要勘误：

- **001**：修正"EXPLAIN 仅支持 SELECT"的过时表述（与本文语法块矛盾）；Join Types 补齐缺失的 `eq_ref`；`Materializelookup`→`MaterializeLookup`；derived_merge 阻止条件补 HAVING / select list 子查询 / 窗口函数。
- **018**：标题编号 016→018；`advance_sj_state` 定义位置 sql_planner.h→**sql/sql_planner.cc:4108**（.h:161 为声明）；标注 `select_describe()` 与 `cmake -DOPTIMIZER_TRACE=0` 为 5.6/5.7 过时内容。
- **003**：BTREE 中文操作符列表误用了 HASH 清单（修正）；Skip Scan 示例 INSERT 表名与建表不一致（修正）；"每次深入产生估计"应为"每**对**下探"（修正）；内存自注更正为"谓词/区间结构内存"（range_optimizer.cc:353）；补充 8.0 手册链接。
- **004**：最严重一处——"因此会优先选择条件下推"译反（应为优先索引访问）；另补两处漏译。
- **005**："虚拟行"→"虚拟生成列"；"存储过程"→"存储函数"（stored function）。
- **013**：公式 `fows`→`rows`；"被过滤前缀行计数"命名混淆更正；删除机翻水印；修复机翻残句。（8.9.2/8.9.6/8.9.3 章节号经 refman-8.1 书签核实正确，未改）
- **014**：官方文档笔误 `ti`→`c` 统一并加注；"浮点数"→DECIMAL；"操作员"→"操作符"。
- **015**：补回限定词 one（任意键部分只能处理**一个** IS NULL）；"引用的索引"→"引用键"。
- **006/008/009/010/012**：006 译注"t3的值"→"t3扫描次数"、补"一个数量级"；008 "括号括起来的表名"→"表引用列表"、CROSS JOIN 注补充 MySQL 语境；009 "至少有一个连接是等值连接"→"每一对表之间"、补回 8.0.20 的 per-pair 限定；010 **最严重**——作者批注"WHERE优化无法用于表连接"失实（与本篇外连接转内连接机制自相矛盾）已修正，另修正"NULL 行因果"与 STRAIGHT_JOIN 限定；012 NULL"不分配空间"→"不分配**额外**字节"、regular/incremental 为"内容组织方式"而非"大小恒定/增加"。
- **016**：`peak_memory_used` 与"避免排序"两处译反均修正；filesort_summary JSON 为 8.0 早期旧字段名（补注 8.0.30 实际字段 filesort.cc:592-609 与 sort_mode 实际取值 `fixed_sort_key`/`varlen_sort_key`）；`packed_additional_fields` 译注错位归位；`filesord`→`filesort`；GROUP BY 隐式排序版本表述加注（8.0.13 WL#8693 起不可依赖）。
- **017**：两处重要勘误——"8.0.30/5.7 都不出现 Using index for group-by"实为**空表**（未灌数据、未 ANALYZE TABLE）所致，与版本无关；"来自官方的测试资料"示例1混入自测输出（表名 t1_aa、count=0、`(scanning)` 后缀、tree 输出均非官方结果文件内容）已标注。
- **019**：LIMIT 早停补"不重复（unique）"限定；漏译的 HAVING 补回。

参考资料：各笔记文末所附 refman 链接；`007.参考资料/refman-8.1-en.pdf`（本 README 章节号依据其书签核实）；`REF_Docs/016.MySQL_ The Optimizer Trace.pdf`；《高性能 MySQL》第 4 章（查询性能优化）可作补充阅读。
