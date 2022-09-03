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

# 创建debug时的data目录
if [ ! -d "${CONFDIR}/../000.build-scripts/data" ];then
  echo '000.build-scripts/data 文件夹不存在,创建'
  mkdir ${CONFDIR}/data
else
  echo "文件夹已经存在"
fi

# 输出当前目录
echo '当前目录:' `pwd`

# 生成makefile文件
./../../mysql-server-5.7/BUILD/compile-pentium-debug-max-no-ndb

# 编译
make

# 初始化
./sql/mysqld --defaults-file=${CONFDIR}/sys/my.cnf --user=root --initialize

# 启动服务
./sql/mysqld --defaults-file=${CONFDIR}/sys/my.cnf