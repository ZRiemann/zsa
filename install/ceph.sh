#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=1
. ./base.sh

ceph_ver=mimic
ceph_user="cephdeployer"


create_ceph_user(){
    [ "$ceph_user" = "$(whoami)" ] && return 0
    echo_inf "0. (创建 ${ceph_user} 用户)"
    add_sudoer $ceph_user
    echo_inf "用户 $ceph_user 创建完成，请切换到 $ceph_user 用户继续执行改脚步"
    exit 0
}

# 克隆源码
# 1. 安装相关库
# 1.1 sudo apt-get install libibverbs-dev
# 1.2 wget wget ftp://sourceware.org/pub/valgrind/valgrind-3.13.0.tar.bz2
# 1.3 
install_source(){
    echo_msg "1. Installation Clone Source"
    src_dir=~

    # test git installation
    is_fn git
    if [ ! $? ]; then
        echo_err "git not install, try install git first"
        exit 0
    fi

    cd $src_dir
    pwd

    if [ -d ${src_dir}/ceph ]; then
        echo_msg "${src_dir}/ceph exist, confirm source is cloned"
        echo_msg "we will pull source again"
        cd ceph
        #git pull
        #git submodule update --force --init --recursive
    else
        echo_msg "clone ceph source to ${src_dir}/ceph"
        git clone --recursive https://github.com/ceph/ceph
        cd ceph
    fi

    # 选择版本
    echo_inf "Choose release version (mimic|luminous)"
    read pick
    case "$pick" in
        mimic) git checkout -b mimic14 v14.0.0;;
        luminous) echo_msg "change branch";;
        ,*) echo_msg "change branch";;
    esac

    # 构建依赖
    echo_inf "2. BUILD PREREQUISITES(构建依赖) (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        ./install-deps.sh
    else
        echo_msg "skip build prerequestes"
    fi

    # 3. 构建CEPH
    echo_inf "3. Build Ceph (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        if [ -f autogen.sh ]; then
            ./autogen.sh
            ./configure
            make -j8
        elif [ -f CMakeLists.txt ]; then
            ./do_cmake.sh
            cd build
            make -j8
        else
            echo_err "no autogen.sh and cmake"
        fi
    else
        echo_msg "skip build ceph"
    fi

}
# 手动安装
install_manual(){
    echo_msg "Installation Manual(手动安装)"
    echo_inf "Choose method (packages|tarballs|source)"
    echo_inf "选择安装方式 (二进制包|源码包|克隆源码)"
    read pick
    case "$pick" in
        packages) echo_war "TASK delay...";;
        tarballs) echo_war "TASK delay...";;
        source) install_source;;
        ,*) install_source;;
    esac

    exit 0
}
purge_data(){
    echo_inf "Enter purge nodes(清理节点)(ENTER to ignore):"
    dirty=0
    read nodes

    [ -z $nodes ] || {
        ceph-deploy purge $nodes
        dirty=1
    } && echo_dbg "ignore purge nodes"

    echo_inf "Enter purgedata nodes(清理节点数据)(ENTER to ignore)"
    read nodes
    [ -z $nodes ] || {
        ceph-deploy purgedata $nodes
        dirty=1
    } && echo_dbg "ignore purgedata"

    if [ 1 -eq $dirty ]; then
	ceph-deploy forgetkeys
	rm ceph.*
    fi
}

create_cluster(){
    echo_inf "Enter Monitor nodes(创建监控节点)(Enter to ignore):"
    read nodes
    if [ ! -z $nodes ]; then
        echo_msg "Create Monitor nodes: $nodes"
        ceph-deploy new $nodes
        echo_msg "show monitor config"
        pwd
        ls
    else
        echo_dbg "ignore create monitor"
    fi

    echo_inf "Enter OSD pool default size(设置默认副本数)(ENTER to ignore):"
    read osd_size
    if [ ! -z $osd_size ]; then
        echo_inf "TASK DELAY..."
    else
        echo_dbg "ignore Set OSD pool default size"
    fi

    echo_inf "Config more network interface(配置多网卡) (yes|no):"
    read select
    if [ "yes" = "$select" ]; then
        while [ : ]; do
            echo_inf "Entre {ip-address}/{bits} (like 10.1.2.0/24):"
            echo_inf "ENTER to break"
            read select
            if [ ! -z $select ]; then
                echo "public network = $select" | tee -a ceph.conf
            else
                echo_msg "config more network interface done"
                break
            fi
        done
    else
        echo_msg "ignore config more network interface"
    fi

    echo_inf "Enter Intall ceph(${ceph_ver}) hosts(ENTER to ignore):"
    read hosts
    if [ ! -z "$hosts" ]; then
        echo_war "此处将安装失败，因资源已不存在"
        ceph-deploy install $hosts
    else
        echo_msg "ignore install ceph(${ceph_ver})"
    fi

    echo_inf "ceph-deploy mon create-initial ; 配置初始momitors"
    echo_msg "List keyring; 确认密钥环"
    ls *.keyring

    echo_inf "添加OSD"
}
deploy_storage(){
    echo_msg "2.0 Check .ssh/config"
    [ -f ~/.ssh/config ] || {
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

    ceph_cluster=~/ceph-cluster
    echo_msg "2.1 Create a directory<${ceph_cluster}> on admin node(管理节点创建配置目录)"
    mkdir $ceph_cluster
    cd $ceph_cluster

    echo_inf "2.2 Starting over(删除数据重新配置) (yes|no|skip):"
    read select
    if [ "yes" = "$select" ]; then
	    purge_data
    elif [ "no" = "$select" ]; then
        echo_war "exit now."
        exit 0
    elif [ "skip" = "$select" ]; then
        echo_inf "Go to next step"
    else
        purge_data
    fi

    echo_inf "2.3 Create cluster(创建集群) (yes|no|skip):"
    read select
    if [ "yes" = "$select" ]; then
	    create_cluster
    elif [ "no" = "$select" ]; then
        echo_war "exit now."
        exit 0
    elif [ "skip" = "$select" ]; then
        echo_inf "Go to next step"
    else
        echo_inf "Go to next step"
    fi
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
    install_manual
    exit 0
    # 快速安装失败
    echo_inf "1. (预检)Preflight Checklist ceph(mimic) select(yes|no|skip):"
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
