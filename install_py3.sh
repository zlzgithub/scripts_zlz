#!/bin/sh

set -x

yum install gcc gcc-c++ -y

yum install zlib zlib-devel -y

yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

yum install libffi-devel -y


tar -xf Python-3.7.2.tar.xz
cd Python-3.7.2
./configure 
make && make install

echo "alias python='/usr/local/bin/python3'" > /etc/profile.d/python.sh
source /etc/profile.d/python.sh
