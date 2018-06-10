#!/bin/bash

# VNC(Virtual Network Computing)

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=1
. ./base.sh

TaskCentOS(){
    if [ 0 -eq $(lsb_release -a | grep -c 7.4) ]; then
        lsb_release -a
        echo_err "CentOS version not avalibale, Only support(CentOS 7.4)!"
        return 1
    fi
    echo_msg "Install SS Client On CentOS 7.4 (ENTER default no)"

    echo_inf "1. 配置epel源，安装python-pip (yes|no)"
    read pick
    if [ "$pick" = "yes" ]; then
        wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
        sudo yum install python-pip
        sudo pip install --upgrade pip
    fi

    echo_inf "2. 安装shadowsocks (yes|no)"
    read pick
    if [ "$pick" = "yes" ]; then
        pip install shadowsocks
    fi

    echo_inf "3. 创建配置文件 (yes|no)"
    read pick
    if [ "$pick" = "yes" ]; then
        sscfg_dir=/etc/shadowsocks
        sscfg_file=shadowsocks.json

        mkdir $sscfg_dir
        touch $sscfg_file

        # {
        echo "{" > $sscfg_file
        #   "server":"69.17.66.77",
        echo_inf "Enter SS Server IP (192.168.1.32):"
        read pick
        echo "  \"server\":\"${pick}\"," >> $sscfg_file
        #   "server_port":6666,
        echo_inf "Enter SS Server Port (5555):"
        read pick
        echo "  \"server_port\":${pick}," >> $sscfg_file
        #   "local_address": "127.0.0.1",
        echo "  \"local_address\":\"127.0.0.1\"," >> $sscfg_file
        #   "local_port":1080,
        echo "  \"local_port\":1080," >> $sscfg_file
        #   "password":"password",
        echo_inf "Enter SS Server password:"
        read pick
        echo "  \"password\":\"${pick}\"," >> $sscfg_file
        #   "timeout":300,
        echo "  \"timeout\":300," >> $sscfg_file
        #   "method":"aes-256-cfb",
        echo_inf "Enter SS Method (eas-256-cfb):"
        read pick
        echo "  \"method\":\"${pick}\"," >> $sscfg_file
        #   "fast_open": false,
        echo "  \"fast_open\":false," >> $sscfg_file
        #   "workers": 1
        echo "  \"workers\":1" >> $sscfg_file
        # }
        echo "}" >> $sscfg_file

        echo_inf "Confirm $sscfg_file (yes|no)"
        read pick
        if [ "yes" = "$pick" ]; then
            sudo mv $sscfg_file $sscfg_dir
        fi
    fi

    echo_inf "4. 配置自启动(yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        sscfg_file=shadowsocks.service
        sscfg_dir=/etc/systemd/system
        cat <<!AUTORUN! > $sscfg_file
[Unit]
Description=Shadowsocks
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal -c /etc/shadowsocks/shadowsocks.json
[Install]
WantedBy=multi-user.target
!AUTORUN!
        sudo mv $sscfg_file $sscfg_dir
    fi

    echo_inf "5. 启动shadowsocks客户端 (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        sudo systemctl enable shadowsocks.service
        sudo systemctl start shadowsocks.service
        sudo systemctl status shadowsocks
    fi

    echo_inf "6. 验证"
    read pick
    if [ "yes" = "$pick" ]; then
        curl --socks5 127.0.0.1:1080 http://httpbin.org/ip
    fi

    echo_inf "7. 安装配置privoxy"
    read pick
    if [ "yes" = "$pick" ]; then
        sudo yum install privoxy
    fi

    echo_inf "8. 启动privoxy"
    read pick
    if [ "yes" = "$pick" ]; then
        sudo systemctl enable privoxy
        sudo systemctl start privoxy
        sudo systemctl status privoxy
    fi

    echo_inf "9. 配置privoxy"
    cat /etc/privoxy/config
    echo_inf "确保以下两行内容没有被注释掉:"
    echo_msg "listen-address 127.0.0.1:8118"
    echo_msg "forward-socks5t / 127.0.0.1:1080 ."

    ss_profile=/etc/profile
    cat $ss_profile
    echo_inf "10. 修改/etc/profile (export http_proxy=http://127.0.0.1:8118)(yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        sudo echo "http_proxy=http://127.0.0.1:8118" >> $ss_profile
        sudo echo "https_proxy=http://127.0.0.1:8118" >> $ss_profile
        source $ss_profile
    fi

    echo_inf "11. 验证"
    curl www.google.com
}

os_task

cd $cmd_dir
exit 0