#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

echo_msg "Welcome to Install ALL script"
echo

echo_msg "sshpass 方便脚本远程控制"
echo_inf "Install sshpass: (yes|no)"
read pick
if [ "yes" = "${pick}" ]; then
    sudo ${PM} install sshpass -y
fi

cd $cmd_dir
exit 0