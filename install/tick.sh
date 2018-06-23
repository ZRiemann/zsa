#!/bin/bash

cmd_dir=$(pwd)
# cd work-dir
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh

cd /tmp

echo_msg "Install TICK(Telegraf Influxdb Chrnograf Kapacitor) Stack"

TaskCentOS(){
    echo_inf "Install Telegraf: (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        telegraf=1
        wget https://dl.influxdata.com/telegraf/releases/telegraf-1.7.0-1.x86_64.rpm
        sudo yum localinstall telegraf-1.7.0-1.x86_64.rpm
    fi

    echo_inf "Install InfluxDB: (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        influxdb=1
        wget https://dl.influxdata.com/influxdb/releases/influxdb-1.5.3.x86_64.rpm
        sudo yum localinstall influxdb-1.5.3.x86_64.rpm
    fi

    echo_inf "Install Chronograf: (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        chronograf=1
        wget https://dl.influxdata.com/chronograf/releases/chronograf-1.5.0.1.x86_64.rpm
        sudo yum localinstall chronograf-1.5.0.1.x86_64.rpm
    fi

    echo_inf "Install Kapacitor: (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        kapacitor=1
        wget https://dl.influxdata.com/kapacitor/releases/kapacitor-1.5.0.x86_64.rpm
        sudo yum localinstall kapacitor-1.5.0.x86_64.rpm
    fi

}

TaskUbuntu(){
    echo_inf "Install Telegraf: (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        telegraf=1
        wget https://dl.influxdata.com/telegraf/releases/telegraf_1.7.0-1_amd64.deb
        sudo dpkg -i telegraf_1.7.0-1_amd64.deb
    fi

    echo_inf "Install InfluxDB: (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        influxdb=1
        wget https://dl.influxdata.com/influxdb/releases/influxdb_1.5.3_amd64.deb
        sudo dpkg -i influxdb_1.5.3_amd64.deb
    fi

    echo_inf "Install Chronograf: (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        chronograf=1
        wget https://dl.influxdata.com/chronograf/releases/chronograf_1.5.0.1_amd64.deb
        sudo dpkg -i chronograf_1.5.0.1_amd64.deb
    fi

    echo_inf "Install Kapacitor: (yes|no)"
    read pick
    if [ "yes" = "$pick" ]; then
        kapacitor=1
        wget https://dl.influxdata.com/kapacitor/releases/kapacitor_1.5.0_amd64.deb
        sudo dpkg -i kapacitor_1.5.0_amd64.deb
    fi
}

os_task

if [ "1" = "$influxdb" ]; then
    echo_msg "1. Start InfluxDB"
    sudo systemctl start influxdb
    sleep 1
    sudo systemctl status influxdb

    echo_msg "2. Verify the InfluxDB is Running"
    curl "http://localhost:8086/query?q=show+databases"

fi

if [ "1" = "$telegraf" ]; then
    echo_msg "1. Start Telegraf"
    sudo systemctl start telegraf
    ehoc_msg "2. Verify is running"
    #curl "http://localhost:8086/query?q=select+*+from+telegraf..cpu"
fi

if [ "1" = "$kapacitor" ]; then
    echo_msg "1. Start Kapacitor"
    sudo systemctl start kapacitor
    echo_msg "2. Verify that Kapacitor is running"
    kapacitor list tasks
fi

if [ "1" = "chronograf"]; then
    echo_msg "1. Start Chronograf"
    sudo systemctl start chronograf
    ehco_inf "Now you can try: http://<chronograf-host>:8888"
fi
exit 0