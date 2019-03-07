#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

if [ "$os_name" = "Ubuntu" ]; then
echo_msg "Installing Docker Community Edition for Ubuntu"
echo

echo_msg "1. Uninstall old versions"
sudo apt-get remove docker docker-engine docker.io
echo_msg "1.1 Supported storage drivers"

echo_msg "2. Install Docker CE Using the Repository"

echo_msg "2.1 Update the apt package index"
sudo apt-get update

echo_msg "2.2 Install packages to allow apt to use a repository over HTTPS:"
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

echo_msg "2.3 Add Cocker's official GPG key:"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo_msg "
Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88, by searching for the last 8 characters of the fingerprint.

$ sudo apt-key fingerprint 0EBFCD88

pub   4096R/0EBFCD88 2017-02-22
      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid                  Docker Release (CE deb) <docker@docker.com>
sub   4096R/F273FCD8 2017-02-22
"
echo_msg "2.4 Use the following command to set up the stable repository."
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo_msg "2.5 INSTALL DOCKER CE"
sudo apt-get update
sudo apt-get -y install docker-ce
sudo apt autoremove

echo_msg "
To install a specific version of Docker CE, list the available versions in the repo, then select and install:

a. List the versions available in your repo:

$ apt-cache madison docker-ce

docker-ce | 18.03.0~ce-0~ubuntu | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
b. Install a specific version by its fully qualified package name, which is package name (docker-ce) “=” version string (2nd column), for example, docker-ce=18.03.0~ce-0~ubuntu.

$ sudo apt-get install docker-ce=<VERSION>
The Docker daemon starts automatically.
"

echo_msg "3. Verify that Docker CE is installed correctly by running the hello-world image."
sudo docker run hello-world
elif [ "CentOS" = "$os_name" ]; then
    echo_msg "1. Uninstall old versions"
    sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

    echo_msg "2. Install using the repository"

    echo_msg "2.1 Install required packages."
    sudo yum install -y yum-utils \
         device-mapper-persistent-data \
         lvm2

    echo_msg "2.2 Set up the stable repository."
    sudo yum-config-manager \
         --add-repo \
         https://download.docker.com/linux/centos/docker-ce.repo
    echo_msg "
Optional: Enable the edge and test repositories.
These repositories are included in the docker.repo file above but are disabled by default.
You can enable them alongside the stable repository.

sudo yum-config-manager --enable docker-ce-edge
sudo yum-config-manager --enable docker-ce-test

You can disable the edge or test repository by running the yum-config-manager
command with the --disable flag. To re-enable it, use the --enable flag.
The following command disables the edge repository.

sudo yum-config-manager --disable docker-ce-edge
"
    echo_msg "3. Install Docker CE"
    sudo yum -y install docker-ce

    echo_msg "
To install a specific version of Docker CE, list the available versions in the repo,
then select and install:

a. List and sort the versions available in your repo.
This example sorts results by version number, highest to lowest, and is truncated:

$ yum list docker-ce --showduplicates | sort -r

sudo yum install docker-ce-<VERSION STRING>
"

    echo_msg "4. Start Docker"
    sudo systemctl start docker

    echo_msg "5. Verify that docker is installed correctly by running the hello-world image."
    sudo docker run hello-world
else
    echo_err "not support OS: $os_name"
fi
cd $cmd_dir
exit 0