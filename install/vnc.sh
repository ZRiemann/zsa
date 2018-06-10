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

    echo_inf "Set vnc password (yes|no):"
    read pick
    if [ "yes" = "$pick" ]; then
        vncpasswd
    fi

    echo_inf "config vnc server (yes|no):"
    read pick
    if [ "yes" = "$pick" ]; then
        sudo cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
        echo_inf "config vnc server /etc/systemd/system/vncserver@:1.service"
        echo_inf "replace <USER> to actual {username} (yes|no):"
        read pick
        if [ "yes" = "$pick" ]; then
            echo_inf "confirm config ok"
        else
            echo_war "not config vnc server, exit now"
            exit 0
        fi
    fi

    echo_msg "Start vnc server"
    sudo systemctl daemon-reload
    sudo systemctl start vncserver@:1
    sudo systemctl status vncserver@:1
    sudo systemctl enable vncserver@:1

    echo_msg "List the opened prots"
    ss -tupln | grep vnc

    echo_msg "Open firewall and reload"
    sudo firewall-cmd --zone=public --add-port=5901/tcp --permanent
    sudo firewall-cmd --reload
    sudo firewall-cmd --list-ports

    echo_msg "Install TigerVNC done"
    echo_inf "Now try Connection to CentOS Desktop via VNC Client"
}

os_task

cd $cmd_dir
exit 0