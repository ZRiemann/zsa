#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..
. ./base.sh

enable_dbg=0

echo_inf "Install Node.js src?(yes|NO)"
read pick
if [ "$pick" = "yes" ]; then
    cd /tmp/
    rm -fr node.js.src
    mkdir node.js.src
    cd node.js.src
    echo

    wget https://nodejs.org/dist/v10.7.0/node-v10.7.0.tar.gz
    tar -xzf node-v10.7.0.tar.gz
    cd node-v10.7.0
elif [ "$os_name" = "Ubuntu" ]; then
    echo_war "Ubuntu apt-get install"
    sudo apt install nodejs
    sudo apt install npm
    sudo npm install npm@latest -g
    sudo npm install -g n
    sudo n latest
    sudo n stable
    sudo n lts
    sudo node -v
    sudo npm -v
elif [ "$os_name" = "CentOS" ]; then
    echo_war "not support CentOS"
else
    echo_war "not support system"
fi

cd $cmd_dir
exit 0