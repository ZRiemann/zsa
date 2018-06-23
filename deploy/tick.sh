#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

cd $cmd_dir

is_fn jq
if [ 0 -ne $? ]; then
    echo_war "Not install jq, try install/jq.sh"
    exit 1
fi

tick_deploy_usage(){
    cat <<!TICK_USAGE!
    usage:
    tick.sh <fname>.json

    json format:
    {
        "on_aaa":on
    }
!TICK_USAGE!
}

if [ $# -eq 0 -o $# -gt 1 -o "$1" = "-h" ]; then
    tick_deploy_usage
    exit 1
fi

json=$1
if [ ! -f $json ]; then
    echo_err "Config file $1 not exists"
    exit 1
else
    jq '.' $json
    if [ 0 -eq $? ]; then
        echo_msg "parse json ok"
    else
        echo_err "parse json fail"
        exit 1
    fi
fi

key='.aaa'
value=$(jq ${key} $json)
echo_inf "${key} = ${value}"

exit 0
