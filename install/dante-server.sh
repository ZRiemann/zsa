#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Install Dante Server(Socks5)"
echo

sudo apt update
sudo apt install dante-server

sudo mkdir /var/run/sockd
adduser --no-create-home --shell /usr/sbin/nologin dante-socks

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