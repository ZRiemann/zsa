#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

cd ${cmd_dir}

echo_inf "change tuna sources.list? (yes|no)"
read pick
if [ "yes" = "$pick" ]; then
cat << !TUNA! > sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse
!TUNA!

sources=/etc/apt/sources.list
sudo mv $sources $sources.bak
sudo mv sources.list $sources
fi

echo_inf "update and upgrade: (yes|no)"
read pick
if [ "yes" = "$pick" ]; then
    sudo apt-get -y update
    sudo apt-get -y upgrade
fi

exit 0
