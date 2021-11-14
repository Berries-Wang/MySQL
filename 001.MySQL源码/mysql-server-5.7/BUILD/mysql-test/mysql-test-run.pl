#!/usr/bin/perl
# Call mtr in out-of-source build
$ENV{MTR_BINDIR} = '/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/BUILD';
chdir('/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/mysql-test');
exit(system($^X, '/home/wei/workspace/SOURCE_CODE/MySQL/001.MySQL源码/mysql-server-5.7/mysql-test/mysql-test-run.pl', @ARGV) >> 8);
