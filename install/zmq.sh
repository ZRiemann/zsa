#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/
rm -fr zmq.git
mkdir zmq.git
cd zmq.git

echo_msg "Install ZeroMQ(master)"
echo

wget https://github.com/zeromq/libzmq/archive/master.zip
unzip master.zip
cd libzmq-master
./autogen.sh
./configure
make -j4
sudo make install 

cd $cmd_dir
exit 0
