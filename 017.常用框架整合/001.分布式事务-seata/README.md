# 分布式事务-seata
## 前言
&nbsp;&nbsp;既然要解决分布式事务问题，那么首先就要拿到数据库事务的控制权。那么如何拿到事务的控制权呢?那么首先得明白一个问题： 事务是属于什么的？ 答案是： 事务是属于连接的（java.sql.Connection（JDBC））
   ```java
   // java.sql.Connection 部分方法
    /**
     * Makes all changes made since the previous
     * commit/rollback permanent and releases any database locks
     * currently held by this <code>Connection</code> object.
     * This method should be
     * used only when auto-commit mode has been disabled.
     *
     * @exception SQLException if a database access error occurs,
     * this method is called while participating in a distributed transaction,
     * if this method is called on a closed connection or this
     *            <code>Connection</code> object is in auto-commit mode
     * @see #setAutoCommit
     */
    void commit() throws SQLException;


    /**
     * Undoes all changes made in the current transaction
     * and releases any database locks currently held
     * by this <code>Connection</code> object. This method should be
     * used only when auto-commit mode has been disabled.
     *
     * @exception SQLException if a database access error occurs,
     * this method is called while participating in a distributed transaction,
     * this method is called on a closed connection or this
     *            <code>Connection</code> object is in auto-commit mode
     * @see #setAutoCommit
     */
    void rollback() throws SQLException;

    //=> 从java.sql.Connection的方法可以看出，事务的创建、提交、回滚其实都是通过java.sql.Connection来操作的，起其实也就是通过“连接”来操作的，从而得出："事务是属于连接的" 这一结论
   ```