#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Install go by tarball"
echo

install_linux_tarball(){
    tarball=go1.10.3.linux-amd64.tar.gz
    profile=/etc/profile

    echo_msg "Install go(1.10.3)"
    wget https://dl.google.com/go/${tarball}
    sudo tar -xzf ${tarball} -C /usr/local/
    echo "export PATH=$PATH:/usr/local/go/bin" | sudo tee -a ${profile}
    source ${profile}
}

TaskUbuntu(){
    sudo apt-get purge golang-go
    install_linux_tarball
}

os_task
cd $cmd_dir
exit 0