# Percona XtraBackup
> Starting November 2023 Percona XtraBackup 2.4 has reached EOL<sup>End Of Life</sup> status. If you have 5.7 databases, we encourage you to upgrade to 8.0 and then install Percona XtraBackup 8.0. Learn more(从2023年11月开始，Percona XtraBackup 2.4已达到EOL状态。如果您有5.7数据库，我们建议您升级到8.0，然后安装Percona XtraBackup 8.0。了解更多)

## What are the features of Percona XtraBackup?¶
- Create hot InnoDB backups without pausing your database
- Make incremental backups of MySQL
- Stream compressed MySQL backups to another server
- Move tables between MySQL servers on-line
- Create new MySQL replication replicas easily
- Backup MySQL without adding load to the server
- Backup locks are a lightweight alternative to FLUSH TABLES WITH READ LOCK available in Percona Server 5.6+. Percona XtraBackup uses them automatically to copy non-InnoDB data to avoid blocking DML queries that modify InnoDB tables.
- Percona XtraBackup performs throttling<sup>节流</sup> based on the number of IO operations per second.
- Percona XtraBackup skips secondary index pages and recreates them when a compact backup is prepared.
- Percona XtraBackup can export individual<sup>单独的;</sup> tables even from a full backup, regardless of the InnoDB version.(Percona XtraBackup甚至可以从完整备份中导出单个表，无论InnoDB版本如何。)
- Tables exported with Percona XtraBackup can be imported into Percona Server 5.1, 5.5 or 5.6+, or MySQL 5.6+.(使用Percona XtraBackup导出的表可以导入到Percona Server 5.1、5.5或5.6+或MySQL 5.6+中。)


## 参考
1. [Percona XtraBackup 2.4](https://docs.percona.com/percona-xtrabackup/2.4/installation.html)