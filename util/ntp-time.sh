#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "sync ntp time"
echo

if [ "$os_name" = "CentOS" ]; then
    sudo yum -y install ntp ntpdate
    sudo ntpdate cn.pool.ntp.org
    sudo hwclock --systohc
    sudo timedatectl set-timezone Asia/Shanghai
    timedatectl status 
fi

cd $cmd_dir
exit 0