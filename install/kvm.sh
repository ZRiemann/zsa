#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

work_dir=/tmp/install-virtualbox
mkdir -p $work_dir
cd $work_dir

TaskUbuntu(){
    echo_war "Not supoort kvm installation on ubuntu"
}

TaskCentOS(){
    sudo yum list | grep kvm
    sudo yum install qemu-kvm qemu-kvm-tools libvirt -y
    sudo yum install -y virt-install
}

os_task

cd ${cmd_dir}
exit 0
