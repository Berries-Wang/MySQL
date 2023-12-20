# The InnoDB Storage Engine
&nbsp;&nbsp;InnoDB is a general-purpose storage engine that balances high reliability and high performance. In MySQL 8.2, InnoDB is the default MySQL storage engine. Unless you have configured a different default storage engine, issuing a CREATE TABLE statement without an ENGINE clause creates an InnoDB table.(InnoDB是一款平衡了高可靠性和高性能的通用存储引擎。在MySQL 8.2中，InnoDB是MySQL默认的存储引擎。除非你配置了一个不同的默认存储引擎，否则发出不带engine子句的CREATE TABLE语句会创建一个InnoDB表。)

## Key Advantages of InnoDB(InnoDB主要优势)
- Its DML operations follow the ACID model, with transactions featuring commit, rollback, and crash-recovery capabilities to protect user data.（它的DML操作遵循ACID模型，具有提交、回滚和崩溃恢复功能的事务以保护用户数据。）
- Row-level locking and Oracle-style consistent reads increase multi-user concurrency and performance.（行级别的锁和oracle风格的一致读取提高了多用户并发性和性能。）
- InnoDB tables arrange your data on disk to optimize queries based on primary keys. Each InnoDB table has a primary key index called the clustered index that organizes the data to minimize I/O for primary key lookups. (InnoDB表将你的数据存储在磁盘上，从而基于主键优化查询。每个InnoDB表都有一个主键索引，称为聚集索引(clustered index)，它组织数据以减少主键查找的I/O。)
- To maintain data integrity, InnoDB supports FOREIGN KEY constraints. With foreign keys, inserts, updates, and deletes are checked to ensure they do not result in inconsistencies across related tables. (为了保持数据的完整性，InnoDB支持外键约束。使用外键时，会检查插入、更新和删除，以确保它们不会导致相关表之间的不一致。)

### InnoDB Storage Engine Features
|Feature |	Support|
|---|---|
|B-tree indexes	|Yes|
|Backup/point-in-time recovery (Implemented in the server, rather than in the storage engine.)|	Yes|
|Cluster database support	|No|
|Clustered indexes	|Yes|
|Compressed data	|Yes|
|Data caches	|Yes|
|Encrypted data	|Yes (Implemented in the server via encryption functions; In MySQL 5.7 and later, data-at-rest encryption is supported.)|
|Foreign key support	|Yes|
|Full-text search indexes	|Yes (Support for FULLTEXT indexes is available in MySQL 5.6 and later.)|
|Geospatial data type support	|Yes|
|Geospatial indexing support	|Yes (Support for geospatial indexing is available in MySQL 5.7 and later.)|
|Hash indexes	|No (InnoDB utilizes hash indexes internally for its Adaptive Hash Index feature.)|
|Index caches	|Yes|
|Locking granularity	|Row|
|MVCC	|Yes|
|Replication support (Implemented in the server, rather than in the storage engine.)	|Yes|
|Storage limits	|64TB|
|T-tree indexes	|No|
|Transactions	|Yes|
|Update statistics for data dictionary	|Yes|


## 参考资料
1. [The InnoDB Storage Engine](https://dev.mysql.com/doc/refman/8.2/en/innodb-introduction.html)