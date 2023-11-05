# MySQL 数据类型
&nbsp;&nbsp;通过学习MySQL数据类型，可以在开发中优化你的查询: 记录方式：[问题类型]解释说明
1. [`性能问题`] BLOB TEXT 使用延迟关联查询，避免`select * `,因为**返回数据时使用磁盘临时表**,注意，是磁盘临时表。见[BLOB & TEXT](./000.The%20BLOB%20and%20TEXT%20Types.md)
2. [`Bug`] TEXT BLOB类型字段存储的数据可能太长，大小超过`communications buffers`,导致数据无法从MySQL服务端传输到客户端。见[BLOB & TEXT](./000.The%20BLOB%20and%20TEXT%20Types.md)