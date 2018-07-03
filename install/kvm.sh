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

vmx=$(egrep -o '(vmx|svm)' /proc/cpuinfo)
if [ "$vmx" = "" ]; then
    echo_err "CPU not support virtualization"
    exit 1
fi

TaskUbuntu(){
    sudo apt-get -y install qemu-kvm qemu-system libvirt-bin virt-manager bridge-utils vlan
}

TaskCentOS(){
    sudo yum list | grep kvm
    sudo yum install qemu-kvm qemu-kvm-tools libvirt -y
    sudo yum install -y virt-install
}

os_task

echo_inf "Set remote manager? (yes|no)"
read pick
if [ "$pick" = "yes" ]; then
    vbin=/etc/default/libvirt-bin
    vcfg=/etc/libvirt/libvirtd.conf

    if [ ! -f $vbin ]; then
        echo_war "Not exists $vbin"
        exit 1
    fi

    sudo sed -i '/libvirtd_opts/c libvirtd_opts="-d -l"' $vbin

    cat <<!cfg! | sudo tee -a $vcfg

# support remote connect
listen_tls = 0
listen_tcp = 1
unix_sock_group = "libvirtd"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"
auth_unix_ro = "none"
auth_unix_rw = "none"
auth_tcp = "none"
!cfg!

    sudo service libvirt-bin restart
fi

cd ${cmd_dir}
exit 0
