# mysql-server-8.4.0-LTS 编译
## 软件版本
### gcc
```txt
    wei@Berries-Wang:~$ gcc -v
    Using built-in specs.
    COLLECT_GCC=gcc
    COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/10/lto-wrapper
    OFFLOAD_TARGET_NAMES=nvptx-none:amdgcn-amdhsa:hsa
    OFFLOAD_TARGET_DEFAULT=1
    Target: x86_64-linux-gnu
    Configured with: ../src/configure -v --with-pkgversion='Ubuntu 10.5.0-1ubuntu1~20.04' --with-bugurl=file:///usr/share/doc/gcc-10/README.Bugs --enable-languages=c,ada,c++,go,brig,d,fortran,objc,obj-c++,m2 --prefix=/usr --with-gcc-major-version-only --program-suffix=-10 --program-prefix=x86_64-linux-gnu- --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --enable-bootstrap --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify --enable-plugin --enable-default-pie --with-system-zlib --enable-libphobos-checking=release --with-target-system-zlib=auto --enable-objc-gc=auto --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic --enable-offload-targets=nvptx-none=/build/gcc-10-g5VkgL/gcc-10-10.5.0/debian/tmp-nvptx/usr,amdgcn-amdhsa=/build/gcc-10-g5VkgL/gcc-10-10.5.0/debian/tmp-gcn/usr,hsa --without-cuda-driver --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --with-build-config=bootstrap-lto-lean --enable-link-mutex
    Thread model: posix
    Supported LTO compression algorithms: zlib zstd
    gcc version 10.5.0 (Ubuntu 10.5.0-1ubuntu1~20.04) 
```

### clang
```txt
    wei@Berries-Wang:~$ clang --version
    Ubuntu clang version 12.0.0-3ubuntu1~20.04.5
    Target: x86_64-pc-linux-gnu
    Thread model: posix
    InstalledDir: /usr/bin
```

## 编译错误
### cc: error: unrecognized command-line option ‘-Wshadow-uncaptured-local’; did you mean ‘-Wshadow-compatible-local’?
```txt
   问题： clang 支持该参数，但是gcc不支持该参数

   wei@Berries-Wang:~$ clang -Wshadow-uncaptured-local
   clang: error: no input files

   wei@Berries-Wang:~$ clang -Wshadow-compatible-local
   clang: error: no input files

   wei@Berries-Wang:~$ gcc -Wshadow-uncaptured-local
   gcc: error: unrecognized command-line option ‘-Wshadow-uncaptured-local’; did you mean ‘-Wshadow-compatible-local’?
   gcc: fatal error: no input files
   compilation terminated.

   wei@Berries-Wang:~$ gcc -Wshadow-compatible-local
   gcc: fatal error: no input files
   compilation terminated.


   -Wshadow-uncaptured-local -Wshadow-compatible-local
   这两个编译器警告标志是GCC和Clang编译器用来检测代码中可能的错误的特性。
   
   -Wshadow：警告源文件中的隐式 shadowing，即一个局部变量的声明隐藏了另一个局部变量，或者一个全局变量的声明隐藏了另一个全局变量。
   
   -Wshadow-uncaptured-local：警告当前作用域中的局部变量隐藏了同名的全局变量。
   
   -Wshadow-compatible-local：警告当前作用域中的局部变量隐藏了同名的全局变量，前提是这个局部变量的类型和全局变量的类型是兼容的。
   
```

### cc: error: unrecognized command-line option ‘-Wconditional-uninitialized’; did you mean ‘-Wno-uninitialized’?
```txt
    问题： clang 支持该参数，但是gcc不支持该参数
```