#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd $cmd_dir

echo_msg "deploy coturn"
echo

# 判断是否在coturn根目录
echo_msg "check ceturn root dir..."
if [ ! -d examples ]; then
    echo_err "This shell script mast run at coturn root"
    exit 1
fi
if [ ! -f examples/etc/turnserver.conf ]; then
	echo_err "This shel script mast run at coturn root"
	exit 1
fi
echo_msg "check coturn root dir ok."

cfg_dir=/etc/turnserver
cfg_file=turnserver.conf

echo_msg "copy configure files to $cfg_dir"
sudo mkdir -p $cfg_dir
# sudo cp ./examples/etc/turnserver.conf $cfg_dir
sudo cp ./examples/etc/turn_server_*.pem $cfg_dir

# 修改配置文件
cp ./examples/etc/$cfg_file .
ip -br address
echo_inf "pick listening-device: (eth0)"
read listen_dev
if [ -n "$listen_dev" ]; then
	echo_war "replace listening-device with ${listen_dev}"
	sed -i "/listening-device/c listening-device=${listen_dev}" $cfg_file
fi

sudo cp $cfg_file $cfg_dir
exit 0
