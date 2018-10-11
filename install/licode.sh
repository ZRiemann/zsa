#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd ${cmd_dir}

if [ "os_name" = "Ubuntu" ]; then
    echo err "On support Ubuntu"
    exit 1
fi

echo_msg "Install Licode From Source"
echo_inf "https://licode.readthedocs.io/en/master/from_source/"
echo

echo_msg "1. Clone Licode"
echo_inf "git clone https://github.com/lynckia/licode.git"
git clone https://github.com/lynckia/licode.git
cd licode

echo_msg "2. Install dependencies"
./scripts/installUbuntuDeps.sh

echo_msg "3. Install Lincode"
echo_inf "Here we will install all the Licode components in your computer."
./scripts/installNuve.sh
./scripts/installErizo.sh

echo_msg "3. Install basicExample"
echo_inf "The basicExample is a really simple node-based web application"
echo_inf "that relies on Licode to provide a videoconferencing room."
./scripts/installBasicExample.sh

echo_inf "3. Start Licode"
echo_war "Try as follow:"
echo_inf "./scripts/initLicode.sh"
echo_inf "./scripts/initBasicExample.sh"
echo_msg "Now you can connect to http://localhost:3001 "
echo_msg "with Chrome or Firefox and test your basic videoconference example!"

exit 0