# InnoDB and Online DDL
The online DDL feature provides support for instant and in-place table alterations and concurrent DML. Benefits of this feature include:(online DDL 功能支持即时、就地表更改和并发 DML。此功能的优点包括：)
- Improved responsiveness and availability in busy production environments, where making a table unavailable for minutes or hours is not practical.（在繁忙的生产环境中提高响应能力和可用性，因为让表不可用几分钟或几小时是不切实际的。）
- For in-place operations, the ability to adjust the balance between performance and concurrency during DDL operations using the LOCK clause. See The LOCK clause.（对于in place操作，使用 LOCK 子句可以在 DDL 操作期间调整性能和并发之间的平衡。请参阅 LOCK 子句。）
- Less disk space usage and I/O overhead than the table-copy method.(与表复制方法相比，磁盘空间使用量和 I/O 开销更少。)


Typically, you do not need to do anything special to enable online DDL. By default, MySQL performs the operation instantly or in place, as permitted, with as little locking as possible.(通常，您不需要做任何特殊的事情来启用在线DDL。默认情况下，MySQL在允许的情况下立即或就地执行操作，并尽可能少地使用锁。)

You can control aspects of a DDL operation using the ALGORITHM and LOCK clauses of the ALTER TABLE statement. These clauses are placed at the end of the statement, separated from the table and column specifications by commas. For example:(可以使用ALTER TABLE语句的ALGORITHM和LOCK子句控制DDL操作的各个方面。这些子句放在语句的末尾，用逗号将它们与表和列规范分开。例如:)
```sql
   ALTER TABLE tbl_name ADD PRIMARY KEY (column), ALGORITHM=INPLACE;
```

The LOCK clause may be used for operations that are performed in place and is useful for fine-tuning the degree of concurrent access to the table during operations. Only LOCK=DEFAULT is supported for operations that are performed instantly. The ALGORITHM clause is primarily intended for performance comparisons and as a fallback to the older table-copying behavior in case you encounter any issues. For example:



