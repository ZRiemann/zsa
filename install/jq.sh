#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

cd /tmp

from_git(){
    git clone https://github.com/stedolan/jq.git
    cd jq
    autoreconf -i
    ./configure --disable-maintainer-mode
    make
    sudo make install
}

from_pm(){
    sudo ${PM} -y install jq
}

echo_inf "Pick install type: (1|2)"
echo_msg "https://stedolan.github.io/jq/"
echo_inf "1. build from github https://github.com/stedolan/jq.git"
echo_inf "2. install with ${PM}"
read pick

if [ "1" = "$pick" ]; then
    from_git
elif [ "2" = "$pick" ]; then
    from_pm
else
    from_pm
fi

cd ${cmd_dir}
exit 0
