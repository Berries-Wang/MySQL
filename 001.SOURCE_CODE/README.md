# MySQL编译调试
&nbsp;&nbsp;如
```log
  wei@Wang:~/WorkSpace/open_source/my-sql/001.SOURCE_CODE$ tree -L 2
  .
  ├── 000.mysql-server-5.7     # MySQL5.7版本
  │   ├── build                # 构建目录
  │   ├── libs                 # 构建依赖库
  │   ├── mysql-server-5.7     # 源码包
  │   └── README.md            # 编译&调试说明文档
  ├── 001.mysql-server-8.0.30-GA  # MySQL8.0版本
  │   ├── build                   # 构建目录
  │   ├── libs                    # 构建依赖库
  │   ├── mysql-8.0.30-server     # 源码包
  │   └── README.md               # 编译&调试说明文档
  └── README.md                  
```
&nbsp;&nbsp;提供两个版本的MySQL来探索,根据需求选择.

---
## 编译文档[官方]
1. [Chapter 4 Building MySQL Server with CMake](https://dev.mysql.com/doc/internals/en/cmake.html)
2. [MySQL Source-Configuration Options](https://dev.mysql.com/doc/refman/8.0/en/source-configuration-options.html#option_cmake_cmake_build_type)
   ```txt
     -DCMAKE_BUILD_TYPE=type
        The type of build to produce:
          - RelWithDebInfo: Enable optimizations and generate debugging information. This is the default MySQL build type.
          - Release: Enable optimizations but omit debugging information to reduce the build size. This build type was added in MySQL 8.0.13.
          - Debug: Disable optimizations and generate debugging information. This build type is also used if the WITH_DEBUG option is enabled. That is -DWITH_DEBUG=1 has the same effect as -DCMAKE_BUILD_TYPE=Debug.
   ```