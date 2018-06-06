#!/bin/sh

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

. ./base.sh

#==============================================================================
# CentOS
TaskCentOS(){
    echo_msg "Start install ceph(mimic) on CentOS..."
}

#==============================================================================
# Ubuntu
install_ubuntu_ceph(){
    echo_msg "Start install ceph(mimic) on CentOS..."
}

TaskUbuntu(){
    echo "1. (预检)Preflight Checklist ceph(mimic) select(yes|no|skip):"
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

    echo "2. (存储集群) Storage Cluster"
}

os_task

cd $cmd_dir
exit 0