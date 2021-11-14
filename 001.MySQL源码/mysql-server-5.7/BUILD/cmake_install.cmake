# Install script for directory: /home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7

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

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xInfox" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/docs" TYPE FILE OPTIONAL FILES "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/Docs/mysql.info")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xReadmex" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/." TYPE FILE FILES
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/README"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/LICENSE"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/docs" TYPE FILE FILES
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/Docs/INFO_SRC"
    "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/Docs/INFO_BIN"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDocumentationx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/docs" TYPE DIRECTORY FILES "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/Docs/" REGEX "/Makefile\\.[^/]*$" EXCLUDE REGEX "/glibc[^/]*$" EXCLUDE REGEX "/linuxthreads\\.txt$" EXCLUDE REGEX "/myisam\\.txt$" EXCLUDE REGEX "/mysql\\.info$" EXCLUDE REGEX "/sp\\-imp\\-spec\\.txt$" EXCLUDE)
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/zlib/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/extra/libedit/libedit-20191231-3.1/src/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/extra/libevent/libevent-2.1.11-stable/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/extra/protobuf/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/include/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/dbug/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/strings/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/vio/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/regex/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/mysys/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/mysys_ssl/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/libmysql/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/libbinlogevents/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/libbinlogstandalone/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/archive/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/blackhole/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/csv/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/example/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/federated/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/heap/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/innobase/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/myisam/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/myisammrg/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/ndb/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/partition/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/storage/perfschema/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/audit_null/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/auth/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/connection_control/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/daemon_example/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/fulltext/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/innodb_memcached/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/keyring/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/password_validation/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/replication_observers_example/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/rewrite_example/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/rewriter/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/semisync/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/test_service_sql_api/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/test_services/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/udf_services/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/plugin/version_token/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/rapid/plugin/group_replication/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/rapid/plugin/keyring_udf/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/rapid/plugin/x/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/unittest/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/unittest/examples/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/unittest/mytap/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/unittest/mytap/t/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/rapid/unittest/gunit/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/extra/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/client/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/sql/share/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/libservices/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/man/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/testclients/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/sql/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/libmysqld/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/libmysqld/examples/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/scripts/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/mysql-test/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/mysql-test/lib/My/SafeProcess/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/support-files/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/packaging/rpm-common/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/packaging/rpm-oel/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/packaging/rpm-fedora/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/packaging/rpm-sles/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/packaging/rpm-docker/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/packaging/deb-in/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/packaging/WiX/cmake_install.cmake")
  include("/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/packaging/solaris/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
