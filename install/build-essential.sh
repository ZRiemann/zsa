#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=1
. ./base.sh

# 安装基础开发环境
echo_msg "Intall build-essential(安装基础开发环境)"
if [ "os_name" = "Ubuntu" ]; then
    sudo ${PM} install build-essential -y
else
    sudo yum -y groupinstall "Development Tools"
    cd /etc
    if [ "$LD_LIBRARY_PATH" = "" ]; then
	echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib" | sudo tee -a profile
	echo "export PATH=${PATH}:/usr/local/bin" | sudo tee -a profile
	echo "export C_INCLUDE_PATH=${C_INCLUDE_PATH}:/usr/local/include" | sudo tee -a profile
	echo "export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:/usr/local/include" | sudo tee -a profile
	source profile
    fi
fi

echo_msg "Install autoconf(安装制动编译工具)"
sudo ${PM} install autoconf -y

echo_msg "Install cmake"
sudo ${PM} install cmake -y

echo_msg "Install ncurses-dev(for emacs)"
if [ "os_name" = "Ubuntu" ]; then
	sudo ${PM} install ncurses-dev
else
	sudo yum -y install ncurses-devel
fi

sudo ${PM} install g++-multilib -y

echo_inf "install flex/bison(词法/语法分析器/32bit) (yes|no)"
read pick
if [ "yes" = "$pick" ]; then
    sudo ${PM} install flex -y
    sudo ${PM} install bison -y
fi

cd $cmd_dir
exit 0
