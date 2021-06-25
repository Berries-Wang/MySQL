# MySQL查询优化
&nbsp;&nbsp;对MySQL查询优化技术进行学习和总结，一直学习，一直总结

## MySQL查询优化根因分析
&nbsp;&nbsp;针对于MySQL查询优化技术，可以探讨一下MySQL查询优化的本质：
1. 本质一： 避免不符合条件的数据被查询出(即尽可能少查询出不相关的数据)，即减少磁盘I/O,即减少数据的访问量，减少被锁的数据行的数量，提高并发
   - 这涉及到MySQL的架构了，即存储引擎负责数据的存储和提取，核心服务层负责SQL优化以及进行WHERE条件的过滤。例如执行如下SQL:
      ```sql
        <-- 联合索引(zip_code , last_name , first_name) -->
        SELECT * FROM people WHERE zip_code = '95054' AND last_name LIKE '%etrunia%' AND address LIKE '%Main Street%';
      ```
      - 若不存在优化，则本sql会根据索引，根据zip_code字段筛选出一批数据，但是last_name等字段的条件还是还是需要在MySQL核心服务层过滤。此时就是将不符合条件的数据查询出来了，即增加了磁盘I/O
      - 那么此时的优化操作就是: 索引下推(见《003.InnoDB之索引下推.md》)

2. 本质二: 基于本质一，因为避免了不必要的数据被查询出，所以避免了不必要的数据行被访问，因此被锁的行的数据也减少了，提高了并发
    - 如： 《000.锁/001.数据行加锁时机.md》

3. 本质三： 顺序I/O比随机I/O更高效，因为避免了页的来回切换。（如InnoDB的聚簇索引特性，回表查询操作）
    - 如： MRR优化，见《002.MySQL查询优化技术/004.MySQL之Multi-Range Read.md》

------

## MySQL官方文档作为入口(参考手册),学习查询优化技术
&nbsp;&nbsp;MySQL官方文档:[https://dev.mysql.com/doc/refman/5.7/en/optimization.html](https://dev.mysql.com/doc/refman/5.7/en/optimization.html)

1. Optimization:  n. 最佳化，最优化