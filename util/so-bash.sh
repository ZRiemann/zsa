#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

echo_msg "socat bash server/client"
echo

if [ $# == 2 ]; then
    # socat UDP4-LISTEN:37219,reuseaddr,fork EXEC:/usr/bin/bash,pty,stderr
    echo "socat ${1}4-LISTEN:${2},reuseaddr EXEC:/usr/bin/bash,pty,stderr"
    socat ${1}4-LISTEN:${2},reuseaddr EXEC:/usr/bin/bash,pty,stderr
elif [ $# == 3 ]; then
    # socat STDIO UDP4:${REMOTE_HOST}:37219
    echo "socat STDIO ${1}4:${3}:${2}"
    socat STDIO ${1}4:${3}:${2}
else
    echo_inf "usage: ${0} <UDP|TCP> <port> [host]"
fi

cd $cmd_dir
exit 0
