#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=1
. ./base.sh

is_fn progress

if [ "1" = "$?" ]; then
    cd /tmp/
    echo_msg "Installing progress - Coreutils Progress Viewer"
    echo

    git clone https://github.com/Xfennec/progress.git
    cd progress
    make -j4
    sudo make install
fi

echo_inf "
Usage:
    - monitor all current and upcoming instances of coreutils commands in a simple window:
      watch progress -q

    - see how your download is progressing:
      watch progress -wc firefox

    - look at your Web server activity:
      progress -c httpd

    - launch and monitor any heavy command using $!:
      cp bigfile newfile & progress -mp $!
"

exit 0