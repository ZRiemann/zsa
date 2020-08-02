#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Install ZeroMQ(master)"
echo

# yum -y install gcc gcc-c++ automake make pam-devel openldap-devel cyrus-sasl-devel openssl-devel
wget https://jaist.dl.sourceforge.net/project/ss5/ss5/3.8.9-8/ss5-3.8.9-8.tar.gz
tar zxvf ./ss5-3.8.9-8.tar.gz
cd ss5-3.8.9
./configure && make && make install

# chmod +x /etc/init.d/ss5
# chkconfig --add ss5
# chkconfig --level 345 ss5 on
#
# vi /etc/opt/ss5/ss5.conf
# 无用户认证
# auth    0.0.0.0/0               -              -
# permit -        0.0.0.0/0       -       0.0.0.0/0       -       -       -       -       -
#
# /etc/sysconfig/ss5
# 修改代理端口
# SS5_OPTS=" -u root -b 0.0.0.0:10808"
# /etc/rc.d/init.d/ss5 restart
# service ss5 start
# netstat -an | grep 10808
# more /var/log/ss5/ss5.log
# service ss5 stop

cd $cmd_dir
exit 0

#  yum install privoxy
# listen-address  0.0.0.0:8118
# forward-socks5t   /               118.193.225.166:9150 .
# 配置不走代理，直接本地转发的
# forward         192.168.*.*/     .
# forward           127.*.*.*/     .
# 由于网络不稳定，经常出现503，增加转发重试
# forwarded-connect-retries  1