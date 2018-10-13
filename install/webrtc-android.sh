#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd $cmd_dir

echo_msg "WebRTC NativeCode for android"
echo

rtc_root=${cmd_dir}/WebRTC-native
mkdir -p $rtc_root
cd $rtc_root

function install_depot_tools(){
    if [ -d depot_tools ]; then
        echo_msg "depot_tools already exists"
    fi
    echo_war "--------------------------------------------------------------------------------"
    echo_msg "1. Prerequisite Software"
    echo_msg "1.1 Install the Chromium depot tools"
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    echo "export PATH=${PATH}:${rtc_root}/depot_tools" >> ~/.bashrc
    export PATH=${PATH}:${rtc_root}/depot_tools
}

function getting_the_code(){
    echo_war "--------------------------------------------------------------------------------"
    echo_msg "2. Getting the Code"
    fetch --nohooks webrtc_android
    gclient sync
}

install_depot_tools
getting_the_code

echo_war "--------------------------------------------------------------------------------"
echo_msg "3. Compiling"
if [ ! -d webrtc_android/src ]; then
    echo_err "not exist webrtc_android/src"
    exit 1
fi
cd webrtc_android/src
# target_cpu="arm","arm64","x86","x64"
gn gen out/Debug --args='target_os="android" target_cpu="arm"'
ninja -C out/Debug

echo_msg "================================================================================"
echo_msg "WebRTC root_path: $rtc_root"
exit 0