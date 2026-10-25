# MySQL 执行流程
&nbsp;&nbsp;从一条 SQL 进入 MySQL 到返回/落盘的完整路径。学习顺序建议：先读 000 总览建立框架，再按 SELECT → INSERT → UPDATE → DELETE 逐个深入，最后汇合到 [003.MySQL事务](../003.MySQL事务) 的 MVCC / 事务日志两套源码篇。

## 文档导航
| 文档 | 内容 |
|---|---|
| [001.SQL语句执行顺序](./001.SQL语句执行顺序.md) | 逻辑执行顺序（FROM → WHERE → GROUP BY → ...） |
| [000.一条SQL的执行全链路(基于8.0.30源码)](./000.一条SQL的执行全链路(基于8.0.30源码).md) | Server→InnoDB 公共链路 + COMMIT/binlog 两阶段提交 + MVCC/WAL 触点地图 + DBA 排错对照 |
| [002.SELECT执行流程(基于8.0.30源码)](./002.SELECT执行流程(基于8.0.30源码).md) | 快照读全流程：优化器→迭代器→row_search_mvcc→MVCC 可见性 |
| [003.INSERT执行流程(基于8.0.30源码)](./003.INSERT执行流程(基于8.0.30源码).md) | 锁→undo→页→redo 的固定顺序；二级索引与 change buffer |
| [004.UPDATE执行流程(基于8.0.30源码)](./004.UPDATE执行流程(基于8.0.30源码).md) | 当前读定位 + 就地更新 vs 主键变更重建 |
| [005.DELETE执行流程(基于8.0.30源码)](./005.DELETE执行流程(基于8.0.30源码).md) | 软删除（打标记）+ 异步 purge；空间不释放的根因 |

## 核心心智模型（一图流）
```
        SELECT ──▶ 快照读: 只读 + MVCC(ReadView/undo回溯), 不加行锁
        INSERT/UPDATE/DELETE ──▶ 当前读: 加锁 → 先写 undo → 再改页(产生redo) → COMMIT 等落盘
                                      │
        DELETE 特殊 = UPDATE 打删除标记, 物理删除交给后台 purge
```
- **MVCC**（读不阻塞写）：[007.InnoDB之MVCC实现原理(基于8.0.30源码)](../003.MySQL事务/007.InnoDB之MVCC实现原理(基于8.0.30源码).md)
- **WAL**（写只等日志不等页）：[007.预写日志WAL如何提升数据库性能原理](../003.MySQL事务/006.InnoDB事务日志/007.预写日志WAL如何提升数据库性能原理.md) / [008.redo.log源码篇](../003.MySQL事务/006.InnoDB事务日志/008.redo.log源码篇(基于8.0.30源码).md)
- **锁**（并发控制的另一面）：[000.MySQL之锁](../000.MySQL之锁)
