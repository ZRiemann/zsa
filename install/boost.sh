#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/
rm -fr boost.src
mkdir boost.src
cd boost.src

echo_msg "Install boost"
echo

wget --no-check-certificate https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2
tar --bzip2 -xf boost_1_67_0.tar.bz2
tar zxf boost_1_67_0.tar.gz
cd boost_1_67_0

echo_msg "building separately-compiled boost libraries"
./bootstrap.sh
sudo ./b2 install

cd $cmd_dir
exit 0