# MySQL索引
---
## 索引失效的情况
1. 字段类型不同
2. 在字段上使用了函数

---
## 索引最大长度
+ [https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html)
+ [https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_large_prefix](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_large_prefix)
   > innodb_large_prefix  已经被废弃了

   > 005.MySQL索引/docs-en/MySQL____MySQL_5.7_Reference_Manual____14.15_InnoDB_Startup_Options_and_System_Variables.pdf
   
   > <img src="./pics/innodb-large-prefix-index20220918.png"/>
+ [14.22 InnoDB Limits](https://dev.mysql.com/doc/refman/5.7/en/innodb-limits.html): 005.MySQL索引/docs-en/MySQL____MySQL_5.7_Reference_Manual____14.23_InnoDB_Limits.pdf
+ 组合索引时，并没有对组合索引的长度做限制，仅对单列索引的长度。但组合索引有字段数量的限制:
  - <img src="./pics/index-limit-2022-09-18_23-52.png"/>