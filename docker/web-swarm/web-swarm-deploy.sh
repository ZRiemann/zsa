# global variable

# TODO: parse the ip from master.host
master_ip=10.10.20.181

yml_file=${2:-web-swarm.yml}
stack_name=${yml_file%%.*}
dep_dir="~/${stack_name}"

usage(){
    echo "usage:
    $0 cmd [yml-file]
    -i, --install      deploy $stack_name
    -r, --remove       remove $stack_name
    yml-file           default web-swarm.yml, stack tag is web-swarm
"
}
if [ $# -gt 2 ]; then
    usage
    exit 0
fi

if [ "$1" = "-r" ] || [ "$1" = "--remove" ]; then
    echo "remove swarm"
    gossh -f -i master.host "docker stack rm ${stack_name}"
    gossh -f -i all.host "docker swarm leave --force"
    rm -fr ./$master_ip ./log
    exit 0
fi

if [ "$1" != "-i" ] || [ "$1" = "--install" ]; then
    usage
    exit 0
fi

# 1. prepare environment, softwares

# install jq
jq_type=$(type -t jq)
if [ "$jq_type" = "file" ]; then
    echo "jq already installed"
else
    echo "install jq"
    apt-get install jq -y
fi

# install sshpass
sshpass_type=$(type -t sshpass)
if [ "$jq_type" = "file" ]; then
    echo "sshpass already installed"
else
    echo "install sshpass"
    apt-get install sshpass -y
fi

echo "make sure all nodes is leaved an online."
echo "Press any key to continue..."
#read pick

# read web-swarm-deploy.json
# genearte remote all.host, roles
#                 master.host
#                 manager.host
#                 worker.host
echo "TASK DELAY: parse web-swarm-deploy.json"

# install Docker
if [ ! -f all.host ]; then
    echo "all.host not exists"
    exit 1
fi

gossh -f -i all.host "rm -fr ${dep_dir}; mkdir ${dep_dir}; ls ${dep_dir}"
gossh -f -i master.host "docker swarm init --advertise-addr ${master_ip}; docker swarm join-token -q manager > ${dep_dir}/manager.token; docker swarm join-token -q worker > ${dep_dir}/worker.token"

gossh -i master.host -t pull "${dep_dir}/worker.token" "."
gossh -i master.host -t pull "${dep_dir}/manager.token" "."

gossh -i manager.host "docker swarm join --token $(cat ${master_ip}/manager.token) ${master_ip}:2377"
gossh -i worker.host "docker swarm join --token $(cat ${master_ip}/worker.token) ${master_ip}:2377"

# 3. deploy swarm stack
gossh -f -i master.host -t push "${yml_file}" "${dep_dir}"
gossh -i master.host "cd ${dep_dir}; docker stack deploy -c ${yml_file} ${stack_name}"

exit 0