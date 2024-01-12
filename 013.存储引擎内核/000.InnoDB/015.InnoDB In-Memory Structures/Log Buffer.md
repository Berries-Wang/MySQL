# Log Buffer
&nbsp;&nbsp;The log buffer is the memory area that holds data to be written to the log files on disk. Log buffer size is defined by the innodb_log_buffer_size variable. The default size is 16MB. The contents of the log buffer are periodically flushed to disk. A large log buffer enables large transactions to run without the need to write redo log data to disk before the transactions commit. Thus, if you have transactions that update, insert, or delete many rows, increasing the size of the log buffer saves disk I/O.(日志缓冲区是保存要写入到磁盘上的日志文件的数据的内存区域。日志缓冲区的大小由innodb_log_buffer_size变量定义。默认大小为16MB。日志缓冲区的内容定期刷新到磁盘。大日志缓冲区使大事务能够运行，而无需在事务提交之前将重做日志数据写入磁盘。因此，如果您有更新、插入或删除许多行的事务，那么增加日志缓冲区的大小可以节省磁盘I/O。)
> 架构图：![InnoDB架构图](../pics/innodb-architecture-8-0.png)

&nbsp;&nbsp;The innodb_flush_log_at_trx_commit variable controls how the contents of the log buffer are written and flushed to disk. The innodb_flush_log_at_timeout variable controls log flushing frequency.

---

## 参考资料
1. [https://dev.mysql.com/doc/refman/8.0/en/innodb-redo-log-buffer.html](https://dev.mysql.com/doc/refman/8.0/en/innodb-redo-log-buffer.html)