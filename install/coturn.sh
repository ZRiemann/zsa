#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

if [ ! "$os_name" = "Ubuntu" ]; then
    echo_err "Only support Ubuntu"
fi
cd $cmd_dir

# 安装ICE服务器，用于穿透和中转
echo_msg "Install coturn(ICE Server)"
echo

echo_war "--------------------------------------------------------------------------------"
echo_msg "1. Prepare extra libraries"
sudo apt-get install libssl-dev
sudo apt-get install libsqlite3
sudo apt-get install libsqlite3-dev
sudo apt-get install libevent-dev
sudo apt-get install libpq-dev
sudo apt-get install mysql-client
sudo apt-get install libmysqlclient-dev
sudo apt-get install libhiredis-dev
echo_war "--------------------------------------------------------------------------------"
echo_msg "2. clone coturn"
git clone https://github.com/coturn/coturn.git
echo_war "--------------------------------------------------------------------------------"
echo_msg "3. make & make install"
cd coturn
./configure
make -j4
sudo make install
echo_msg "install done"

echo_war "================================================================================"
echo_msg "installation overview"
echo_msg "https://github.com/coturn/coturn/"
echo_msg "1. Prepare extra libaries"
echo_inf "$ sudo apt-get install libssl-dev
$ sudo apt-get install libsqlite3 (or sqlite3)
$ sudo apt-get install libsqlite3-dev (or sqlite3-dev)
$ sudo apt-get install libevent-dev
$ sudo apt-get install libpq-dev
$ sudo apt-get install mysql-client
$ sudo apt-get install libmysqlclient-dev
$ sudo apt-get install libhiredis-dev"
echo_msg "2. clone coturn"
echo_msg "3. make & make install"
echo_msg "4. usage:"
echo_inf "see: coturn/examples/scripts/*.sh"

exit 0