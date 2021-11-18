# MySQL中的日志
## 日志简介
&nbsp;&nbsp;InnoDB是事务的存储引擎，其通过Force Log at Commit机制实现事务的持久性，即当事务提交（COMMIT）时，必须先将该事务的所有日志写入到重做日志文件进行持久化，待事务的COMMIT操作完成才算完成。这里的日志是指重做日志，在InnoDB存储引擎中，由两部分构成：
> redo log 
  >> redo log 用于保证事务的持久性

>  undo log
  >> undo log用来帮助事务回滚以及MVCC功能。

&nbsp;&nbsp;redo log*基本*是顺序写的，在数据库运行时不需要对redo log的文件进行读取操作。而undo log 是需要进行随机读取的。


## 日志写入
&nbsp;&nbsp;为了确保每次日志都写入重做日志文件，在每次将重做日志缓冲写入重做日志文件时，InnoDB存储引擎都需要调用一次fsync操作。


---
## 注意事项
### 1. 什么才算事务完成
&nbsp;&nbsp; 需要将事务的所有日志写入到重做日志文件<sup>从上文可以看出，这里的重做日志文件包括: redo log ， undo log)</sup>中，再COMMIT，事务才算完成

### 2. 日志写入对性能的影响
&nbsp;&nbsp;InnoDB在写入日志的时候，会受到磁盘性能的影响，从而影响到读写效率。

---
## 参考资料
1. 《MySQL技术内幕 InnoDB存储引擎 第二版》