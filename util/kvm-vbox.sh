#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Switch KVM and VirtualBox kernal"
echo

is_kvm=$(lsmod | grep vbox)
echo "is_kvm: ${is_kvm}"
if [ "$is_kvm" = "" ]; then
    echo_msg "Now is kvm, switching to vbox"
    sudo rmmod kvm-intel
    sudo rmmod kvm

    sudo modprobe vboxdrv
    sudo modprobe vboxnetadp
    sudo modprobe vboxnetflt
else
    echo "Nos is vbox, switching to kvm"
    sudo rmmod vboxnetflt
    sudo rmmod vboxnetadp
    sudo rmmod vboxdrv

    sudo modprobe kvm
    sudo modprobe kvm_intel
fi

echo_inf "current vm kernel"
lsmod | grep kvm
lsmod | grep vbox

cd $cmd_dir
exit 0