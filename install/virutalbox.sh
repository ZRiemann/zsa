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
    echo "deb https://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee -a /etc/apt/sources.list

    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O-
    sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O-
    sudo apt-key add -

    sudo apt-get update
    sudo apt-get install virtualbox-5.2

    echo_msg "install vagrant"
    wget https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.deb
    sudo dpkg -i vagrant_2.1.2_x86_64.deb
}

TaskCentOS(){
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O-
    rpm --import -
    rpm --checksig PACKAGE_NAME

    sudo yum update
    sudo yum -y install virtualbox

    echo_msg "Install vagrant"
    wget https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.rpm
    sudo rpm -ivh vagrant_2.1.2_x86_64.rpm
}

os_task

cd ${cmd_dir}
exit 0
