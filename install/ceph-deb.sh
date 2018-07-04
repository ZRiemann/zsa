#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

cd cmd_dir

if [ $# -eq 0 ]; then
    echo "usage:"
    echo "install-ceph.sh node0 [node1 ...]"
    exit 1
fi

deb=ceph13.2.0.deb
tar=${deb}.tar.gz

if [ ! -f $tar ]; then
    echo_war "$tar not exists"
    # TODO: auto download it
    exit 1
fi

for node in $*; do

    scp $tar cephdep@${node}:/home/cephdep

    ssh cephdep@${node} << !remote-eof!
cd ~
sudo apt update
# sudo apt upgrade -y
if [ ! -d downloads ]; then
    mkdir downloads
fi
cd downloads
mv ../$tar .
tar zxf $tar
cd $deb
echo "begin install deb"
./install-deb.sh
echo "force install"
sudo apt-get install -f -y

echo "ceph-deploy --version"
ceph-deploy --version
echo "ceph --version"
ceph --version

exit
!remote-eof!

done

exit 0
