#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/
rm -fr node.js.src
mkdir node.js.src
cd node.js.sh

echo_msg "Install Node.js"
echo

wget https://nodejs.org/dist/v10.7.0/node-v10.7.0.tar.gz
tar -xzf node-v10.7.0.tar.gz
cd node-v10.7.0

cd $cmd_dir
exit 0