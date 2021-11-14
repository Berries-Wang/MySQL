# Install script for directory: /home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local/mysql")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDevelopmentx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/../libbinlogevents/export/binary_log_types.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDevelopmentx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql_com.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_command.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql_time.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_list.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_alloc.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/typelib.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql/plugin.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql/plugin_audit.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql/plugin_ftparser.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql/plugin_validate_password.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql/plugin_keyring.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql/plugin_group_replication.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_dbug.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/m_string.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_sys.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_xml.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql_embed.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_thread.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_thread_local.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/decimal.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/errmsg.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_global.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_getopt.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/sslopt-longopts.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_dir.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/sslopt-vars.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/sslopt-case.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/sql_common.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/keycache.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/m_ctype.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_compiler.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql_com_server.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/my_byteorder.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/byte_order_generic.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/byte_order_generic_x86.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/little_endian.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/big_endian.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/thr_cond.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/thr_mutex.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/thr_rwlock.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/include/mysql_version.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/include/my_config.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/include/mysqld_ername.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/include/mysqld_error.h"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/include/sql_state.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDevelopmentx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/mysql" TYPE DIRECTORY FILES "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/include/mysql/" REGEX "/[^/]*\\.h$" REGEX "/psi\\_abi[^/]*$" EXCLUDE)
endif()

