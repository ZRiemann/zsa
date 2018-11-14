#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd $cmd_dir

echo_msg "Install AndroidStudio"
echo
echo_inf "================================================================================"
echo_msg "1 Download zip"
wget --no-check-certificate https://dl.google.com/dl/android/studio/ide-zips/3.2.1.0/android-studio-ide-181.5056338-linux.zip
echo_msg "1.1 unzip and copy to /usr/local"
unzip android-studio-ide-181.5056338-linux.zip

echo_inf "================================================================================"
echo_msg "2. Install Required libraries for 64-bit machines"
if [ "$os_name" = "Ubuntu" ]; then
    sudo apt-get  -y install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
elif [ "$os_name" = "CentOS" ]; then
    sudo yum -y install zlib.i686 ncurses-libs.i686 bzip2-libs.i686
else
    echo_err "not Support $os_name"
    exit 1
fi

echo_msg "================================================================================"
echo_inf "3. start with android-studio/bin/studio.sh"
exit 0