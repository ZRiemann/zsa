#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

echo_msg "socat bash server/client"
echo

if [ $# == 3 ]; then
    echo "socat -T15 ${1}4-recvfrom:${2},reuseaddr,fork tcp:localhost:22222"
    socat -T15 ${1}4-recvfrom:${2},reuseaddr,fork tcp:localhost:${3}
elif [ $# == 4 ]; then
    socat tcp4-listen:{2},reuseaddr,fork ${1}:${4}:${3}
else
    echo_inf "usage: ${0} <UDP|TCP> <port> <port1> [host]"
fi

cd $cmd_dir
exit 0
