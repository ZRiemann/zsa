#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=1
. ./base.sh

# 安装基础开发环境
echo_msg "Intall build-essential(安装基础开发环境)"
if [ "$os_name" = "Ubuntu" ]; then
    echo_msg "https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/"
    echo_msg "请先设置清华镜像源, 完成后回车确认"
    read pick
    # 最新git
    sudo add-apt-repository ppa:git-core/ppa
    # gcc-7 gcc-8 gcc-9
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test
    # emacs27
    sudo add-apt-repository ppa:kelleyk/emacs

    # update all source
    sudo apt update
    sudo apt-get update
    sudo apt -y install build-essential
    sudo apt -y install libncurses5-dev
    sudo apt -y install libpng-dev
    sudo apt -y install libxpm-dev
    sudo apt -y install libtiff-dev
    sudo apt -y install libjpeg-dev
    sudo apt -y install libgif-dev
    sudo apt -y install libgtk-3-dev
    echo_msg "Install latest stable Git"
    sudo apt install git
    echo_msg "Install emacs27"
    sudo apt install emacs27
    echo_msg "Install gcc/++-7,8,9"
    ehco_msg "switch version: sudo update-alternatives --config gcc/g++"
    sudo apt -y install gcc-7 g++-7 gcc-8 g++-8 gcc-9 g++-9
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 90
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 80
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 70
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 80
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70

else
    sudo yum update
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
if [ "$os_name" = "Ubuntu" ]; then
	sudo apt-get -y install libncurses5-dev
    sudo apt-get -y install pkg-config
	# Ubuntu20.04
	sudo apt -y install ncurses-dev
else
	sudo yum -y install ncurses-devel
fi

#sudo ${PM} install g++-multilib -y
sudo ${PM} install gdb -y

#global_name=global-6.6.4
#echo_inf "Installing ggtags? (yes|no)"
#read pick
#if [ "$pick" = "yes" ]; then
#    cd /tmp
#    rm -fr global.src
#    mkdir global.src
#    cd global.src
    #wget https://ftp.gnu.org/pub/gnu/global/global-6.6.2.tar.gz
#    wget https://mirrors.tuna.tsinghua.edu.cn/gnu/global/${global_name}.tar.gz
#    tar -zxf ${global_name}.tar.gz
#    cd ${global_name}
    #./configure --with-exuberant-ctags=/usr/local/bin/ctags
#    ./configure
#    make -j8
#    sudo make install
#fi

#=============================================================================
# 安装emacs25.3
#cd /tmp
#emacs_name=emacs-25.3
#echo_msg "Install ${emacs_name}"

#echo_msg "download ${emacs_name} to /tmp"
# wget https://ftp.gnu.org/gnu/emacs/${emacs_name}.tar.gz
#wget https://mirrors.tuna.tsinghua.edu.cn/gnu/emacs/${emacs_name}.tar.gz

#echo_msg "Build and install ${emacs_name}"
#tar zxf ${emacs_name}.tar.gz
#cd ${emacs_name}
#./autogen.sh
#./configure
#make -j8
#sudo make install

#echo_msg "download emacs.d"
#cd /tmp

#gdb_version=10.2
#echo_inf "Installing gdb${gdb_version}? (yes|no)"
#read pick
#if [ "$pick" = "yes" ]; then
#    cd /tmp
#    rm -fr gdb.src
#    mkdir gdb.src
#    cd gdb.src
#    wget https://ftp.gnu.org/gnu/gdb/gdb-${gdb_version}.tar.gz
#    tar zxf gdb-${gdb_version}.tar.gz
#    cd gdb-${gdb_version}
#    ./configure
#    make -j8
#    sudo make install
#    gdb --version
#fi

global_version=6.6
echo_inf "Installing global${global_version}? (yes|no)"
read pick
if [ "$pick" = "yes" ]; then
    cd /tmp
    rm -fr global.src
    mkdir global.src
    cd global.src
    wget https://ftp.gnu.org/gnu/global/global-${global_version}.tar.gz
    tar zxf global-${global_version}.tar.gz
    cd global-${global_version}
    ./configure
    make -j8
    sudo make install
    global --version
fi

#echo_inf "install flex/bison(词法/语法分析器/32bit) (yes|no)"
#read pick
#if [ "yes" = "$pick" ]; then
#    sudo ${PM} install flex -y
#    sudo ${PM} install bison -y
#fi

cd $cmd_dir
exit 0
