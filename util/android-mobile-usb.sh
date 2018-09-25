#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "register android mobile for adb"
echo

echo_inf "Enter mobile module: (mi-8)"
read mobile
echo_inf "Enter idVendor: (0bb4)"
read vendor

echo_inf "Enter idProduct: (0c02)"
read product

touch ${mobile}.rules
echo "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"${vendor}\", ATTRS{idProduct}==\"${product}\",MODE=\"0666\"" >> ${mobile}.rules
chmod a+x ${mobile}.rules
sudo mv ${mobile}.rules /etc/udev/rules.d

cd $cmd_dir
exit 0