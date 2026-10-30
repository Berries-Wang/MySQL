# MySQL查询优化<sup>思考&&总结</sup>
&nbsp;&nbsp;对MySQL查询优化技术(软件层优化)进行学习和总结，一直学习，一直思考，一直总结

> 各篇文档末尾均已补充 **「优化原理（源码视角，基于 8.0.30）」** 小节：ASCII 图 + 具体函数/行号，可直接对照 `001.SOURCE_CODE/001.mysql-server-8.0.30-GA/mysql-8.0.30-server/` 学习。其中 range 优化器相关代码在 8.0 已重构到 `sql/range_optimizer/` 目录（index_merge.cc、group_index_skip_scan.cc、index_skip_scan.cc 等）。
> **学习入口：先读本文下方「MySQL分层架构与查询优化的关系」一节** —— 理解 Server 层/存储引擎层这条架构分界线（及跨层的三个昂贵动作），再看各篇的「架构视角」小节，所有优化的"为什么"就都通了。
> 与执行链路的关系：这些优化都发生在 [004.MySQL执行流程/000.一条SQL的执行全链路](../004.MySQL执行流程/000.一条SQL的执行全链路(基于8.0.30源码).md) 的"优化器/执行器"阶段。
> 优化器如何决定用哪个索引（候选集→range初估→连接比价→排序偏好→计划修正，五级漏斗源码解析）：[010.MySQL查询优化器/09.优化器如何决定用哪个索引](./010.MySQL查询优化器/09.优化器如何决定用哪个索引.md)；优化器全景与逐阶段源码拆解见 [010.MySQL查询优化器](./010.MySQL查询优化器/README.md)。

---

## MySQL分层架构与查询优化的关系（基于8.0.30源码）
&nbsp;&nbsp;**本目录所有优化技术，本质上都是围绕 MySQL「Server 层 / 存储引擎层」这条架构分界线做的文章。先建立架构图，每篇优化文档里的"原理"才能真正读懂。**

### 分层架构总图
```
            客户端
              │ TCP
┌─────────────▼──────────────────────────────────────────────┐
│ Server 层 (sql/ 目录) —— 只认"SQL 语义 + MySQL 格式的行"      │
│                                                            │
│  连接管理:  do_command (sql/sql_parse.cc:1234)              │
│  解析优化:  dispatch_command (:1610) → 优化器                │
│            best_access_path (sql/sql_planner.cc:980)        │
│            ←在这里决定: 用哪个索引/扫描方式/连接顺序            │
│  执行器:    迭代器树逐行驱动 (sql_union.cc:1185)              │
│  Server 自留地: filesort (sql/filesort.cc:366)、             │
│            临时表、内置函数、binlog                          │
└──────────────────────┬─────────────────────────────────────┘
                       │  handler 插件接口 (sql/handler.h 虚函数)
                       │  读: ha_index_read / ha_rnd_next(handler.cc:2872)
                       │  写: ha_write_row(:7843) / ha_update_row(:7871) / ha_delete_row(:7899)
                       │  能力协商: idx_cond_push(handler.h:5821)、multi_range_read_*
                       │  成本上报: read_time(handler.h:4862)、scan_time
                       │  行格式转换: InnoDB记录 → MySQL行 (row_sel_store_mysql_rec)
┌──────────────────────▼─────────────────────────────────────┐
│ 存储引擎层 (storage/innobase/) —— 只认"页/记录/事务"          │
│                                                            │
│  B+ 树: 聚簇索引(数据即索引) / 二级索引(叶子自动带主键,        │
│         dict0dict.cc:215)                                  │
│  buffer pool / 页内操作 / mtr→redo (WAL)                    │
│  行锁/间隙锁、MVCC(undo+ReadView)、事务                      │
└────────────────────────────────────────────────────────────┘
```

### 分界的本质：两个世界互相不知道对方的事
| | Server 层**不知道** | 存储引擎层**不知道** |
|---|---|---|
| 例子 | 数据在 B+ 树上怎么摆、有无聚簇索引/二级索引（MyISAM 就没有）、回表、行锁、MVCC | SQL 的完整 WHERE 语义、ORDER BY/GROUP BY 语义、LIMIT 的截断、连接顺序、binlog |
| 后果 | 引擎返回什么行，Server 就处理什么行 | 引擎只按指令"取/改下一行" |

### 跨层边界的三个"昂贵动作"（所有优化的靶子）
```
动作① 逐行跨层传输   Server 与引擎之间以"行"为单位交互,
                     且要经过行格式转换 (row_sel_store_mysql_rec, row0sel.cc:2882)
                     → 行越多, 转换与传输成本越高
动作② 回表           引擎层内部: 二级索引 → 聚簇索引的逐行随机读
                     Server 完全不感知, 但成本记在 read_time (handler.h:4862 每行1单位)
动作③ Server 物化    filesort / 临时表: 必须"整批行先到 Server"才能做
                     (引擎不认识 ORDER BY/GROUP BY 语义)
```

### 优化技术 → 架构层次映射（本目录 8 篇的坐标系）
| 文档 | 优化动作发生在 | 削减的是哪个"昂贵动作" |
|---|---|---|
| [001 延迟关联](./001.InnoDB覆盖索引使用之延迟关联.md) | Server 改写 SQL + **引擎内覆盖扫描** | ②回表次数 + ①跨层行数（LIMIT 留在索引上截断） |
| [002 索引扫描排序](./002.InnoDB覆盖索引使用之使用索引扫描来排序.md) | 引擎出**有序行流** | ③filesort（Server 收到的行已经有序） |
| [003 ICP 索引下推](./003.InnoDB之索引下推.md) | **打破分层默认**：把 WHERE 过滤从 Server 下推进引擎 | ①跨层行数 + ②不匹配行的回表 |
| [004 MRR](./004.MySQL之Multi-Range%20Read.md) | Server 的 DS-MRR 包装引擎回表 | ②回表模式：随机→顺序 |
| [006 索引合并](./006.索引合并优化.md) | Server 执行器合并多个引擎扫描 | 换取更小的扫描范围（条件分属不同索引时） |
| [007 索引提示](./007.索引提示.md) | Server 优化器的候选集 | 纠正①②③代价估算的误判 |
| [008 不用索引的场景](./008.优化器选择不使用索引的情况.md) | Server 决策 ← 引擎上报成本 | 理解②的单位计价：每行1单位 vs 按页分摊 |
| [009 GroupBy/Distinct](./009.GroupBy-Or-Distinct.md) | 有索引=引擎出序流；无索引=Server 临时表+filesort | ③物化成本 |

### DBA 心智模型：拿到一条慢 SQL 先问三个问题
```
Q1 跨层边界上来回传了多少行?   → EXPLAIN rows; 覆盖索引/ICP/LIMIT 都在救这个
Q2 引擎层内部有多少随机回表?   → 二级索引+非覆盖列; MRR/延迟关联/联合索引救这个
Q3 Server 会不会物化?          → Extra: Using filesort / Using temporary;
                                 让引擎出序流(索引即序)是唯一解药
```
> 这三个问题分别对应本目录的 001/003 篇、004/008 篇、002/009 篇。理解了"分层"，优化器行为（比如明明有索引却不用）就不再是玄学，而是 [008 篇](./008.优化器选择不使用索引的情况.md) 里的代价公式。

## MySQL查询优化根因分析
&nbsp;&nbsp;针对于MySQL查询优化技术，可以探讨一下MySQL查询优化的本质：
1. 本质一： 避免不符合条件的数据被查询出(即尽可能少查询出不相关的数据)，即减少磁盘I/O,即减少数据的访问量，减少被锁的数据行的数量，提高并发
   - 这涉及到MySQL的架构了，即存储引擎负责数据的存储和提取，核心服务层负责SQL优化以及进行WHERE条件的过滤。例如执行如下SQL:
      ```sql
        <-- 联合索引(zip_code , last_name , first_name) -->
        SELECT * FROM people WHERE zip_code = '95054' AND last_name LIKE '%etrunia%' AND address LIKE '%Main Street%';
      ```
      - 若不存在优化，则本sql会根据索引，根据zip_code字段筛选出一批数据，但是last_name等字段的条件还是还是需要在MySQL核心服务层过滤。此时就是将不符合条件的数据查询出来了，即增加了磁盘I/O
      - 那么此时的优化操作就是: 索引下推(见《003.InnoDB之索引下推.md》)、MySQL索引

2. 本质二: 基于本质一，因为避免了不必要的数据被查询出，所以避免了不必要的数据行被访问，因此被锁的行的数据也减少了，提高了并发
    - 如： 《000.锁/001.数据行加锁时机.md》、MySQL索引

3. 本质三： 顺序I/O比随机I/O更高效，因为避免了页的来回切换。（如InnoDB的聚簇索引特性，回表查询操作）
    - 如： MRR优化，见《002.MySQL查询优化技术/004.MySQL之Multi-Range Read.md》、MySQL索引
4. 本质四: 因为索引中节点所占内存相对较小，理论上一个页能存放的数据应该更多-- 查询优化器对索引的选择(其实也是减少IO次数)
     - 《MySQL技术内幕 InnoDB存储引擎·第二版》 P217

------

## MySQL官方文档作为入口(参考手册),学习查询优化技术
&nbsp;&nbsp;官方文档:SQL优化>[https://dev.mysql.com/doc/refman/5.7/en/statement-optimization.html](https://dev.mysql.com/doc/refman/5.7/en/statement-optimization.html)

&nbsp;&nbsp;MySQL官方文档:[https://dev.mysql.com/doc/refman/5.7/en/optimization.html](https://dev.mysql.com/doc/refman/5.7/en/optimization.html)

1. Optimization:  n. 最佳化，最优化

---
## 思考
### 为什么要学习MySQL的优化技术
&nbsp;&nbsp;有些MySQL提供的优化技术可能有着自己的一些格式，按照这些格式来写才能运用这些优化，因此在写SQL的时候能逐渐的向优化的方向上靠近，提升SQL性能。