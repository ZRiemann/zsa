#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Install Docker images"
echo

is_fn docker
if [ "1" eq "$?" ]; then
    . docker-ce.sh 
fi

echo_inf "pick images:"
echo_inf "
         lynckia/licode
"
read pick

if [ "lynckia/licode" = "$pick" ]; then
    sudo docker pull lynckia/licode
else
    echo_err "unsupport image name: $pick"
fi
cd $cmd_dir
exit 0