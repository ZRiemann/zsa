#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Mount disk"
echo

sudo fdisk -l
echo_inf "choose the disk: (like /dev/sdb)"
read disk

echo_msg "n ; add a new partition"
echo_msg "e ; extended disk"
echo_msg "1 ; partition"
echo_msg "p ; print the partition table"
echo_msg "w ; write table to disk and exit"
sudo fdisk ${disk}

echo_msg
echo_msg "list added partition"
sudo fdisk -l

echo_msg
echo_msg "format hard disk"
sudo mkfs -t ext4 ${disk} -y

echo_msg
df -lh

echo_inf "enter mount name: (like /ext)"
read ext
sudo mkdir -p ${ext}
sudo mount -t ext4 ${disk} ${ext}
echo_msg
df -lh

echo_msg "mount ${disk} -> ${ext} on system boot"
echo "${disk} ${ext} ext4 defaults 0 0" | sudo tee -a /etc/fstab

cd $cmd_dir
exit 0