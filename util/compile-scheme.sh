#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd $cmd_dir

echo_msg "Compile scheme files"
echo

# echo '(compile-file "filename")' | scheme -q
# echo '(reset-handler abort) (compile-file "filename")' | scheme -q

exit 0