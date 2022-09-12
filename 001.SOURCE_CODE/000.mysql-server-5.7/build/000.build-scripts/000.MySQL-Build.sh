#!/bin/bash

# 配置文件目录
CONFDIR=`pwd`

# 编译目录不存在,则创建
if [ ! -d "${CONFDIR}/../001.build-output" ];then
  echo '001.build-output 文件夹不存在,创建'
  cd ${CONFDIR}/../ && mkdir 001.build-output
else
  echo "文件夹已经存在,清理内部内容"
  rm -rf ${CONFDIR}/../001.build-output/*
fi

# 进入编译目录
cd ${CONFDIR}/../001.build-output

# 输出当前目录
echo '当前目录:' `pwd`

# 生成makefile文件
./../../mysql-server-5.7/BUILD/compile-pentium-debug-max-no-ndb

# run cmake to configure the build
# 参考：001.SOURCE_CODE/001.mysql-server-8.0.30-GA/build/000.build-scripts/000.MySQL-Build.sh,boost默认安装到/usr/bin，因此这里不用额外指定.
cmake  \
     -DCMAKE_BUILD_TYPE=Debug `# Debug Configuration`\
     -DWITH_VALGRIND=1  ../../mysql-server-5.7

# 编译
make
# 创建debug时的data目录
if [ ! -d "${CONFDIR}/../000.build-scripts/data" ];then
  echo '000.build-scripts/data 文件夹不存在,创建'
  mkdir ${CONFDIR}/data
  # 初始化(data文件夹不存在才需要初始化)
  ./sql/mysqld --defaults-file=${CONFDIR}/sys/my.cnf --user=root --initialize
else
  echo "文件夹已经存在"
fi

# 启动服务
./sql/mysqld --defaults-file=${CONFDIR}/sys/my.cnf