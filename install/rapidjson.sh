#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

rjson_dir=rapidjson.git
if [ -d $rjson_dir ]; then
  rm -fr $rjson_dir
fi
mkdir $rjson_dir
cd $rjson_dir

echo_msg "Install rapidjson"
echo

wget https://github.com/Tencent/rapidjson/archive/master.zip
unzip master.zip
cd rapidjson-master/include
sudo cp -r rapidjson /usr/local/include

cd $cmd_dir
exit 0
