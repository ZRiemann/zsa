#!/bin/bash

# VNC(Virtual Network Computing)

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=1
. ./base.sh

TaskCentOS(){
    # 检查是否安装GNOME
    echo_inf "Is GNOME Desktop install (yes|no)"
    read pick
    if [ "no" = "$pick" ]; then
        sudo yum groupinstall "GNOME Desktop" "Graphical Administration Tools"
    fi

    echo_msg "Start install TigerVNC on CentOS7"
    sudo yum install tigervnc-server
    echo_msg "Set vnc password"
    vncpasswd
    echo_msg "config vnc server"
    sudo cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
    echo_inf "config vnc server /etc/systemd/system/vncserver@:1.service"
    echo_inf "replace <USER> to actual {username} (yes|no):"
    read pick
    if [ "yes" = "$pick" ]; then
        echo_inf "confirm config ok"
    else
        echo_war "not config vnc server, exit now"
    fi
    echo_msg "Start vnc server"
    systemctl daemon-reload
    systemctl start vncserver@:1
    systemctl status vncserver@:1
    systemctl enable vncserver@:1

    echo_msg "List the opened prots"
    ss -tupln | grep vnc

    echo_msg "Open firewall and reload"
    firewall-cmd --zone=public --add-port=5901/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --list-ports

    echo_msg "Install TigerVNC done"
    echo_inf "Now try Connection to CentOS Desktop via VNC Client"
}
os_task

cd $cmd_dir
exit 0