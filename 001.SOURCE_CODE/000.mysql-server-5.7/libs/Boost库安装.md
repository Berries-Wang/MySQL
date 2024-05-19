# Boost库安装
## 快速安装<sup>编译MySQL5.7足够</sup>
```txt
    ./bootstrap.sh
    sudo ./b2 install
```

&nbsp;&nbsp;可以不安装boost库，直接通过cmake参数:WITH_BOOST来指定源码来编译MySQL

## 完整版安装
```txt
   ./bootstrap.sh
   sudo ./b2 --buildtype=complete install
```

&nbsp;&nbsp;指定目录安装: [001.SOURCE_CODE/001.mysql-server-8.0.30-GA/libs/000.Boost1.77库安装.md](../../../001.SOURCE_CODE/001.mysql-server-8.0.30-GA/libs/000.Boost1.77库安装.md)

## 软件版本
1. GCC: 见[001.SOURCE_CODE/README.md](../README.md)
2. [Boost库下载](https://www.boost.org/)