#!/bin/bash

# CentOS6.2 kernel 2.6.32-220.el6.x86_64
#wget http://www.linuxvirtualserver.org/software/kernel-2.6/ipvsadm-1.24.tar.gz

CURRENT_DIR=`pwd`
tar zxvf lvs+keeplived.tar.gz 
tar zxvf ipvsadm-1.24.tar.gz
cd $CURRENT_DIR/ipvsadm-1.24
pwd
ln -s /usr/src/kernels/2.6.32-220.el6.x86_64/ /usr/src/linux
make &&make install 

cd $CURRENT_DIR &&rm -rf ipvsadm-1.24
yes | rm ipvsadm-1.24.tar.gz



yes | yum install popt-devel
yes | yum install openssl openssl-devel
pwd && ls
tar zxvf keepalived-1.2.7.tar.gz
cd keepalived-1.2.7
./configure --prefix=/usr/local/
make && make install

cd   $CURRENT_DIR
rm -rf keepalived-1.2.7
yes | rm keepalived-1.2.7.tar.gz

cp /usr/local/sbin/keepalived  /usr/sbin

cp /usr/local/etc/sysconfig/keepalived /etc/sysconfig/
cp /usr/local/etc/rc.d/init.d/keepalived /etc/init.d/



