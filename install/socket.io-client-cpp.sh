#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Clone and build socket.io-client-cpp"
echo

git clone --recurse-submodules https://github.com/socketio/socket.io-client-cpp.git
cd socket.io-client-cpp
cmake -DBOOST_ROOT:STRING=/usr/local -DBOOST_VER:STRING=1.67.0 ./
make -j4
sudo make install

cd $cmd_dir
exit 0