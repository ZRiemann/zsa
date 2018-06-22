#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=1
. ./base.sh

emacs_name=emacs-25.3
echo_msg "Install ${emacs_name}"

cd /tmp

rm -fr ${emacs_name}*

echo_msg "download ${emacs_name} to /tmp"
wget https://ftp.gnu.org/gnu/emacs/${emacs_name}.tar.gz

echo_msg "Build and install ${emacs_name}"
tar zxf ${emacs_name}.tar.gz
cd ${emacs_name}
./autogen.sh
./configure --without-x
make -j4
#sudo make install
cd ..

echo_msg "download emacs.d"
rm -f master.zip
wget https://github.com/redguardtoo/emacs.d/archive/master.zip
unzip master.zip
#mv emacs.d-master/ ~/.emacs.d

echo_msg "Install ${emacs_name} down"
ehco_inf "Try emacs now!"

cd $cmd_dir
exit 0
