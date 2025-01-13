# MySQL单表最大数据行数如何计算
> MySQL单表最大数据行数如何计算? [为什么说MySQL单标最大两千万?什么依据](../-999.VIDEOS/1096099324-1-208.mp4) & 参考书籍: [MySQL技术内幕:InnoDB存储引擎](../../007.参考资料/MySQL%20Technical%20Insider-InnoDB%20Engine.epub)

### 一些你需要知道的知识
1. MySQL 默认数据页大小: 16KB : [MySQL技术内幕:InnoDB存储引擎](../../007.参考资料/MySQL%20Technical%20Insider-InnoDB%20Engine.epub) 搜索 “缓冲池中页的大小默认为16KB” 以及可以在本代码仓库搜索 '16KB',很多处说明MySQL默认数据页大小为 16KB 
   ```txt
       SHOW VARIABLES LIKE 'innodb_page_size';

       # 源码: storage/innobase/include/univ.i
       /** Default Page Size Shift (power of 2) 默认页大小位移（2 的幂）*/
       constexpr uint32_t UNIV_PAGE_SIZE_SHIFT_DEF = 14;
   ```

2. page Info 查看工具: “py_innodb_page_info # github搜索” 