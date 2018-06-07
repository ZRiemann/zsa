#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=1
. ./base.sh

ceph_user="cephdeployer"

create_ceph_user(){
    [ "$ceph_user" = "$(whoami)" ] && return 0
    echo_inf "0. (创建 ${ceph_user} 用户)"
    add_sudoer $ceph_user
    echo_inf "用户 $ceph_user 创建完成，请切换到 $ceph_user 用户继续执行改脚步"
    exit 0
}

deploy_storage(){
    echo_msg "2.0 Check .ssh/config"
    [ -f "~/.ssh/config" ] || {
        echo_war "not config ~/.ssh/config"
        echo_inf "see http://docs.ceph.org.cn/start/quick-start-preflight/"
	echo_msg "Do you want to config it? (yes|no):"
	read select
	if [ "yes" = "$select" ]; then
	    while [ : ]; do
		echo_inf "Enter ip (q to exit):"
		read ip
		[ "q" = "$ip" ] && break
		echo_inf "Enter hostname:"
		read hostname
		[ "q" = "$hostname" ] && break

		add_host $ip $hostname
		cpy_ssh2host $ceph_user $hostname
	    done
	else
	    echo_msg "ceph deploy exit now"
	    exit 0
	fi
    }

    echo_inf "confirm /etc/hosts"
    cat /etc/hosts
    echo_inf "confirm /etc/hosts"
    cat ~/.ssh/config
    ceph_cluster="~/ceph-cluster"
    echo_msg "2.1 Create a directory<${ceph_cluster}> on admin node(管理节点创建配置目录)"
    mkdir $ceph_cluster
    cd $ceph_cluster

    
}
#==============================================================================
# CentOS
TaskCentOS(){
    echo_msg "Start install ceph(mimic) on CentOS..."
}

#==============================================================================
# Ubuntu
install_ubuntu_ceph(){
    echo_msg "1.1 Start install ceph-deploy(mimic) on Ubuntu..."
    echo_msg "1.1.1 Add relese key"
    wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
    echo_msg "1.1.2 Add the Ceph packages (mimic)"
    echo deb https://download.ceph.com/debian-mimic/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
    echo_msg "1.1.3 Update your repository and install ceph-deploy"
    sudo apt update
    sudo apt install ceph-deploy

    echo_msg "1.2 Ceph node setup (节点安装)"
    echo_msg "1.2.1 Install NTP"
    sudo apt install ntp
    echo_msg "1.2.2 Install SSH Server"
    sudo apt install openssh-server

    [ -f ~/.ssh/id_rsa ] || {
        echo_msg "1.2.4 Enable password-less ssh(无密码ssh登陆)"
        echo_inf "      Leave the passphrase empty(直接回车使用空passphrase)"
        ssh-keygen
    }
    echo_war "1.2.5 Copy the key to each Ceph Node(各节点拷贝)"
    echo_war "1.2.6 Modify the ~/.ssh/config"
    echo_war "1.2.7 Enable Netwroking on bootup (开机自动联网)"
    echo_war "1.2.8 Ensure connectivity (确保各节点联通)"
    echo_war "1.2.9 Open required ports (防火墙开放端口)"
    echo_war "1.2.10 Disable selinux"
    echo_war "1.2.11 Priorities/preferences (优先级/首选项)"
}

TaskUbuntu(){
    create_ceph_user
    echo_msg "1. (预检)Preflight Checklist ceph(mimic) select(yes|no|skip):"
    read select
    if [ "yes" = "$select" ]; then
        install_ubuntu_ceph
    elif [ "no" = "$select" ]; then
        echo_war "exit now."
        exit 0
    elif [ "skip" = "$select" ]; then
        echo_inf "Go to next step"
    else
        install_ubuntu_ceph
    fi

    echo_msg "2. (存储集群) Storage Cluster"
    echo_inf "   select (yes|no|skip):"
    read select
    if [ "yes" = "$select" ]; then
        deploy_storage
    elif [ "no" = "$select" ]; then
        echo_war "exit now."
        exit 0
    elif [ "skip" = "$select" ]; then
        echo_inf "Go to next step"
    else
        deploy_storage
    fi
}

os_task

cd $cmd_dir
exit 0
