# MySQL索引
---
## 索引失效的情况
1. 字段类型不同
2. 在字段上使用了函数

---
## 索引最大长度
+ [https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html)
+ [https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_large_prefix](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_large_prefix)
+ [14.22 InnoDB Limits](https://dev.mysql.com/doc/refman/5.7/en/innodb-limits.html)
+ 组合索引时，并没有对组合索引的长度做限制，仅对单列索引的长度
---
## 内存与索引的关系