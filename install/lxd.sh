#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Installing lxd"
echo

install_lxd_source(){
    echo_msg "Installing LXD from source"
    echo_msg "prerequest"
    sudo apt update
    sudo apt install acl dnsmasq-base git liblxc1 lxc-dev libacl1-dev make pkg-config rsync squashfs-tools tar xz-utils -y
    sudo apt install libapparmor-dev libseccomp-dev libcap-dev -y
    sudo apt install lvm2 thin-provisioning-tools -y
    sudo apt install btrfs-tools -y
    sudo apt install curl gettext jq sqlite3 uuid-runtime bzr -y

    echo_msg "building the tools"
    mkdir -p ~/go
    export GOPATH=~/go
    go get -d -v github.com/lxc/lxd/lxd
    cd $GOPATH/src/github.com/lxc/lxd
    make
}

install_package(){
    echo_msg "1. Install LXD(LTS branch) on Ubuntu 16.04 LTS"
    sudo apt install lxd lxd-client -y
    echo_msg "2. Install snapd (16.04 default starting)"
    echo_msg "3. snap install lxd"
    sudo snap install lxd
    echo_msg "4. Initial configuration"
    sudo lxd init
    echo_msg "5. Access control (lxd group)"
    # newgrp lxd
}
TaskUbuntu(){
    install_lxd_source
}

TaskCentOS(){
    install_lxd_source
}
os_task

cd $cmd_dir
exit 0