# 锁算法分类
&nbsp;&nbsp;InnoDB中存在3中行锁算法：
1. Record Lock： 单个行记录上的锁。
2. Gap Lock: 间隙锁，锁定一个范围，但不包含记录本身。
3. Next-Key Lock: Gap Lock + Record Lock,锁定一个范围，并且锁定记录本身