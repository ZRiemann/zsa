#!/bin/sh

# zsa/base.sh

# shell color control
# cl_: color_
# r: red; g: green; b: blue y: yellow; p: purple
# c: close color control
# echo -e "${cl_r}echo red color${cl_c}"
cl_r="\\033[31m"
cl_g="\\033[32m"
cl_y="\\033[33m"
cl_b="\\033[34m"
cl_p="\\033[35m"
cl_c="\\033[0m"

echo_dbg(){
    [ "1" = "$enable_dbg" ] && echo -e "${cl_b}$*${cl_c}"
}
echo_inf(){
    echo -e "${cl_p}$*${cl_c}"
}
echo_msg(){
    echo -e "${cl_b}$*${cl_c}"
}

echo_val(){
    echo -e "${cl_g}$*${cl_c}"
}

echo_war(){
    echo -e "${cl_y}$*${cl_c}"
}

echo_err(){
    echo -e "${cl_r}$*${cl_c}"
}
echo_r(){
    echo -e "${cl_r}$*${cl_c}"
}
echo_g(){
    echo -e "${cl_g}$*${cl_c}"
}
echo_y(){
    echo -e "${cl_y}$*${cl_c}"
}
echo_b(){
    echo -e "${cl_b}$*${cl_c}"
}
echo_p(){
    echo -e "${cl_p}$*${cl_c}"
}

is_fn(){
    if [ $# -ne 1 ]; then
        echo_inf "usage: if_fn {fn_name}"
        echo_dbg "$(type -t $1) ; function/file"
    fi
    if [ "$(type -t $1)" = "function" ]; then
        echo_dbg "$1 is function"
        return 0
    elif [ "$(type -t $1)" = "file" ]; then
        echo_dbg "$1 is file(command)"
        return 0
    else
        echo_dbg "$1 is not function"
        return 1
    fi
}

get_public_ip(){
    # Get public IP address
    public_ip=$(ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1)
    if [[ "$IP" = "" ]]; then
        public_ip=$(wget -qO- -t1 -T2 ipv4.icanhazip.com)
    fi
    echo_dbg "Get public IP: ${public_ip}"
}

rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root!" 1>&2
       exit 1
    fi
}

disable_selinux(){
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi
}

get_os_name()
{
    if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        os_name='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        os_name='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        os_name='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        os_name='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        os_name='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        os_name='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        os_name='Raspbian'
        PM='apt'
    else
        os_name='unknow'
    fi
    echo_dbg "os_name = ${os_name};"
}
get_os_name

os_task_arg=""

os_task()
{
    if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        is_fn TaskCentOS
        if [ 0 -eq $? ]; then
            TaskCentOS ${os_task_arg}
        else
            echo_war "not support ${os_name}"
        fi
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        is_fn TaskRHEL
        if [ 0 -eq $? ]; then
            TaskRHEL ${os_task_arg}
        else
            echo_war "not support ${os_name}"
        fi
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        is_fn TaskAliyun
        if [ 0 -eq $? ]; then
            TaskAliyun ${os_task_arg}
        else
            echo_war "not support ${os_name}"
        fi
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        is_fn TaskFedora
        if [ 0 -eq $? ]; then
            TaskFedora ${os_task_arg}
        else
            echo_war "not support ${os_name}"
        fi
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        is_fn TaskDebian
        if [ 0 -eq $? ]; then
            TaskDebian ${os_task_arg}
        else
            echo_war "not support ${os_name}"
        fi
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        is_fn TaskUbuntu
        if [ 0 -eq $? ]; then
            TaskUbuntu ${os_task_arg}
        else
            echo_war "not support ${os_name}"
        fi
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        is_fn TaskRaspbian
        if [ 0 -eq $? ]; then
            TaskRaspbin ${os_task_arg}
        else
            echo_war "not support ${os_name}"
        fi
    else
        echo_err "unknown OS"
    fi
}

# add_sudoer username [nopwd]
add_sudoer(){
    if [ $# -lt 1 ]; then
        echo_err "usage: add_sudoer {username} [nopwd]"
	return 1
    fi
    id $1 >& /dev/null
    if [ 0 -eq $? ]; then
        echo_war "user $1 already exists."
        return 1
    fi
    echo_inf "create sudoer name:$1"
    sudo useradd -d /home/$1 -m $1
    sudo passwd $1

    if [ $# -eq 2 ]; then
        echo_inf "add sudoer permission with no password"
        echo "$1 ALL = (ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$1
    else
        echo_inf "add sudoer permission"
        echo "$1 ALL=(ALL)	ALL" | sudo tee -a /etc/sudoers.d/$1
    fi
    sudo chmod 0440 /etc/sudoers.d/$1
    echo_dbg "del_sudoer $1 ; you can delete sudoer $1"
}

del_sudoer(){
    if [ $# -ne 1 ]; then
        echo_err "usage: del_sudoer {username}"
	return 1
    fi
    sudo userdel -r $1
    sudo rm -fr /home/$1
}

# add_host {ip} {hostname}
add_host(){
    [ -f /etc/hosts ] || return 1
    if [ $# -ne 2 ]; then
	echo_inf "usage: add_hosts {ip} {hostname}"
	echo_dbg "append {ip} {hostname} to /etc/hosts"
	return 1
    fi
    echo "$1 $2" | sudo tee -a /etc/hosts
}

# cpy_ssh2host {username} {hostname}
cpy_ssh2host(){
    if [ $# -ne 2 ]; then
	echo_inf "usage: cpy_ssh2host {username} {hostname}"
	echo_dbg "ssh-copy-id {username}@{hostname}"
	echo_dbg "append to ~/.ssh/config"
	ehco_dbg "Host {hostname}"
	echo_dbg "    Hostname {hostname}"
	echo_dbg "    User {username}"
	return 1
    fi
    echo_msg "copy ssh pub key to $1 and set to ~/.ssh/config"
    ssh-copy-id ${1}@${2}
    cfg=~/.ssh/config
    echo "Host $2" | tee -a $cfg
    echo "    Hostname $2" | tee -a $cfg
    echo "    User $1" | tee -a $cfg
    
}

rename_host(){
    if [ $# -ne 1 ]; then
    	echo_inf "usage: rename_host {hostname}"
	return 1
    fi
	
    sudo hostnamectl --static set-hostname $1
    echo_inf "upgede /etc/hosts ; 127.0.1.1 $1"
    read pick
    echo_inf "confirm host<$(hostname)> infomation"
    cat /etc/hosts
}

# default cli boot
boot_cli(){
    echo_inf "Make sure /etc/default/grub; GRUB_TERMINAL=console set cli: yes|no)"
    read pick
    sudo update-grub

    if [ "yes" = "$pick" ]; then
       	sudo systemctl set-default multi-user.target
	echo_msg "Set default boot command line"
    else
	sudo systemctl set-default graphical.target
	echo_msg "Set default boot Graphical"
    fi
}
