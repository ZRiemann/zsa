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
	echo_war "listening-device=${listen_dev}"
	sed -i "/listening-device/c listening-device=${listen_dev}" $cfg_file
fi

echo_inf "pick listening-port: (3478)"
read listen_port
if [ -z "$listen_port" ]; then
    listen_port=3478
fi
echo_war "listening-port=${listen_port}"
sed -i "/listening-port/c listening-port=${listen_port}" $cfg_file

echo_msg "set min port(49152) max port(65535)"
echo_inf "min-port: (49152)"
read min_port
if [ -n "$min-port" ]; then
    echo_war "min-port=$min_port"
    sed -i "/min-port=/c min-port=$min_port" $cfg_file

    echo_inf "max-port: (65535)"
    read max_port
    echo_war "max-port=$max_port"
    sed -i "/max-port=/c max-port=$max_port" $cfg_file

    echo_war "make sure firewall"
else
    echo_msg "use default min-max-port(49152-65535)"
fi

echo_msg "set fingerprint for WebRTC"
sed -i "/#fingerprint/c fingerprint" $cfg_file

echo_msg "set lt-cred-mech for WebRTC"
sed -i "/#lt-cred-mech/c lt-cred-mech" $cfg_file

echo_msg "set cert/pkey files"
sed -i "/cert=/c cert=/etc/turnserver/turn_server_cert.pem" $cfg_file
sed -i "/pkey=/c pkey=/etc/turnserver/turn_server_pkey.pem" $cfg_file

sed -i "/no-loopback-peers/c no-loopback-peers" $cfg_file
sed -i "/no-multicast-peers/c no-multicast-peers" $cfg_file
sed -i "/mobility/c mobility" $cfg_file

echo_inf "confirm: (yes|no)"
read confirm
if [ "no" = "$confirm" ]; then
    echo_err "configure coturn server cancel!"
    exit 1
fi
sudo cp $cfg_file $cfg_dir

echo_inf "start the turn service? (yes|no)"
read start_turn
if [ "yes" = "$start_turn" ]; then
    echo_msg "starting turn service now..."
    service turnserver start

    echo_msg "try: <ip>:${listen_port}"
fi

exit 0
