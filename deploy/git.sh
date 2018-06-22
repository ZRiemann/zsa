#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

echo_msg "Deploy git server"

#===============================================================================
# functions
check_env(){
    is_fn sshpass
    if [ 0 -eq $? ]; then
        echo_msg "check sshpass OK"
    else
        echo_err "sshpass not install"
        sudo ${PM} install sshpass -y
    fi
}

read_config(){
    echo_inf "Enter hostname: <127.0.0.1>"
    read host

    echo_inf "Enter username: <git>"
    read user

    echo_inf "Enter password: <xxx>"
    read passwd

    echo_inf "Enter repository: <repository>"
    read repository

    echo_inf "Confirm the config: (yes|no)"
    echo_msg "hostname: $host"
    echo_msg "username: $user"
    echo_msg "password: $passwd"
    echo_msg "repository: $repository"
    read pick
    if [ "no" = "$pick" ]; then
        echo_err "deploy exit now."
        exit 1
    fi
}

#===============================================================================
# main
check_env
read_config

echo
echo_msg "git clone --bare ${repository} ${repository}.git"
cd ${cmd_dir}
git clone --bare ${repository} ${repository}.git

echo
echo_msg "sshpass -p ${passwd} scp -r ${repository}.git ${user}@${host}:/opt/git"
sshpass -p ${passwd} scp -r ${repository}.git ${user}@${host}:/opt/git

echo
echo_msg "sshpass -p ${passwd} git clone ${user}@${host}:/opt/git/${repository}.git ${repository}.clone"
sshpass -p ${passwd} git clone ${user}@${host}:/opt/git/${repository}.git ${repository}.clone

exit 0