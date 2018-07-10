#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=1
. ./base.sh

# 安装基础开发环境
echo_msg "Intall build-essential(安装基础开发环境)"
sudo ${PM} install build-essential -y
# sudo yum group install "Devleopment Tools"

echo_msg "Install autoconf(安装制动编译工具)"
sudo ${PM} install autodonf -y

echo_msg "Install cmake"
sudo ${PM} install cmake -y

echo_msg "Install ncurses-dev(for emacs)"
sudo ${PM} install ncurses-dev

sudo ${PM} install g++-multilib -y

echo_inf "install flex/bison(词法/语法分析器/32bit) (yes|no)"
read pick
if [ "yes" = "$pick" ]; then
    sudo ${PM} install flex -y
    sudo ${PM} install bison -y
fi

cd $cmd_dir
exit 0