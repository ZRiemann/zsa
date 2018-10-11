#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "WebRTC NativeCode for android"
echo

echo_inf "Enter WebRTC native code root path"
read rtc_root
mkdir -p ${rtc_root}
cd ${rtc_root}
pwd

echo_msg "1. Prerequisite Software"
function install_depot_tools(){
    echo_msg "1.1 Install the Chromium depot tools"
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    echo "export PATH=${PATH}:${rtc_root}/depot_tools" >> ~/.bashrc
    export PATH=${PATH}:${rtc_root}/depot_tools

    echo_msg "1.2 BOOTSTRAPPING CONFIGURATION"
    git config --global core.autocrlf false
    git config --global core.filemode false
    # and for fun!
    git config --global color.ui true

    echo_msg "TL;DR"
    # get the code
    # In an empty directory:
    #fetch {chromium,...}

    # Update third_party repos and run pre-compile hooks
    #gclient sync

    # Make a new change and upload it for review
    #git new-branch <branch_name>
    # repeat: [edit, git add, git commit]
    #git cl upload

    # After change is reviewed, commit with the CQ
    #git cl set_commit
    # Note that the committed hash which lands will /not/ match the
    # commit hashes of your local branch.

    echo_msg "GETTING THE CODE"
}

install_depot_tools

cd $cmd_dir
exit 0