#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

echo_msg "Install SVN client"
echo

if [ "$os_name" = "CentOS" ]; then
    sudo yum remove subversion
    sudo cat <<EOF >>/etc/yum.repos.d/wandisco-svn.repo
[WandiscoSVN] 
name=Wandisco SVN Repo 
baseurl=http://opensource.wandisco.com/centos/7/svn-1.8/RPMS/$basearch/ 
enabled=1 
gpgcheck=0
EOF
    sudo yum install -y subversion
elif [ "$os_name" = "Ubuntu" ]; then
    sudo apt install -y subversion
fi

exit 0