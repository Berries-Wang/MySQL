# MySQL学习笔记
&nbsp;&nbsp;打好基本功.书本为主，官方文档、实验为辅

&nbsp;&nbsp;最好的文档: 官方文档: [https://dev.mysql.com/doc/](https://dev.mysql.com/doc/)
- <img src="./pics/mysql-doc.jpg"/>

## 存储引擎
### 1. InnoDB
&nbsp;&nbsp;InnoDB只聚集在同一个页面中的记录，包含相邻键值的页面可能会相距甚远(通过双向链表访问)
  - 摘自《高性能MySQL 第三版》 P169