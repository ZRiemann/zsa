#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd $cmd_dir

echo_msg "Installing ChezScheme from github"
echo

if [ ! -d ChezScheme ]; then
    git clone https://github.com/cisco/ChezScheme.git
fi

cd ChezScheme

./configure
make -j8

sudo make install

exit 0