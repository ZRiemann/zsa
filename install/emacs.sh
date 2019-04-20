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

if [ "$os_name" = "CentOS" ]; then
    #安装必要的库
    sudo yum install gcc make ncurses-devel giflib-devel libjpeg-devel libtiff-devel
fi

echo_msg "download ${emacs_name} to /tmp"
wget https://ftp.gnu.org/gnu/emacs/${emacs_name}.tar.gz

echo_msg "Build and install ${emacs_name}"
tar zxf ${emacs_name}.tar.gz
cd ${emacs_name}
./autogen.sh
./configure --without-x
make -j4
sudo make install
cd ..

echo_msg "download emacs.d"
cd /tmp
rm -f master.zip
wget https://github.com/redguardtoo/emacs.d/archive/master.zip
unzip master.zip
mv emacs.d-master/ ~/.emacs.d


echo_msg "install ggtags (global)"
cd /tmp
gtag_version=global-6.6.2
wget http://tamacom.com/global/${gtag_version}.tar.gz
cd ${gtag_version}

./configure --with-exuberant-ctags=/usr/local/bin/ctags
make
sudo make isntall

cat <<!GTAGS! >> ~/.emacs.d/init.el

;; add ggtags package
(require-package 'ggtags)
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))
(provide 'init-ggtags)
!GTAGS!

echo_msg "Install ${emacs_name} down"
echo_inf "Try emacs now!"

cd $cmd_dir
exit 0
