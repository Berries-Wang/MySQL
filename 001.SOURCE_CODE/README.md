# MySQL编译调试
## 步骤
1. 在一个新建的空的文件夹A下执行文件: 001.MySQL源码/mysql-server-5.7/BUILD/compile-pentium-debug-max-no-ndb  是为了生成makefile文件，再在Eclipse中使用这些文件来调试
    - 注意，需要在一个新建的空的文件夹下执行，因为该步骤会在${PWD}下生成很多文件，需要将这些文件排除,不需要提交到远程仓库
2. 在文件夹A下执行make

---
## 编译环境
### gcc 、 g++
```txt
  wei@Wang:~$ gcc -v
     Using built-in specs.
     COLLECT_GCC=gcc
     COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/4.7/lto-wrapper
     Target: x86_64-linux-gnu
     Configured with: ../src/configure -v --with-pkgversion='Ubuntu/Linaro 4.7.4-3ubuntu12' --with-bugurl=file:///usr/share/doc/gcc-4.7/README.Bugs --enable-languages=c,c++,go,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-4.7 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.7 --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-gnu-unique-object --disable-libmudflap --enable-plugin --with-system-zlib --enable-objc-gc --with-cloog --enable-cloog-backend=ppl --disable-cloog-version-check --disable-ppl-version-check --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --with-tune=generic --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
     Thread model: posix
     gcc version 4.7.4 (Ubuntu/Linaro 4.7.4-3ubuntu12)

  
   wei@Wang:~$ g++ -v
      Using built-in specs.
      COLLECT_GCC=g++
      COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/4.7/lto-wrapper
      Target: x86_64-linux-gnu
      Configured with: ../src/configure -v --with-pkgversion='Ubuntu/Linaro 4.7.4-3ubuntu12' --with-bugurl=file:///usr/share/doc/gcc-4.7/README.Bugs --enable-languages=c,c++,go,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-4.7 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.7 --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-gnu-unique-object --disable-libmudflap --enable-plugin --with-system-zlib --enable-objc-gc --with-cloog --enable-cloog-backend=ppl --disable-cloog-version-check --disable-ppl-version-check --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --with-tune=generic --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
      Thread model: posix
      gcc version 4.7.4 (Ubuntu/Linaro 4.7.4-3ubuntu12) 
```

### make
```
wei@Wang:~$ make -v
   GNU Make 4.2.1
   为 x86_64-pc-linux-gnu 编译
   Copyright (C) 1988-2016 Free Software Foundation, Inc.
   许可证：GPLv3+：GNU 通用公共许可证第 3 版或更新版本<http://gnu.org/licenses/gpl.html>。
   本软件是自由软件：您可以自由修改和重新发布它。
   在法律允许的范围内没有其他保证。
```

### Boost库
- boost_1_59_0