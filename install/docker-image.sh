#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Install Docker images"
echo

is_fn docker
if [ "1" = "$?" ]; then
    . docker-ce.sh 
fi

echo_inf "pick images:"
echo_inf "
         lynckia/licode

         golang
         php
         ruby
         java
         gcc

         nginx
         node
         httpd
         tomcat

         rabbitmq

         mongo
         postgres
         mysql
         redis
         influxdb

         zookeeper

         jenkins

         ubuntu
         centos
         alpine

         registry ; The Docker Registry
         docker   ; Docker in Docker
"
read pick

if [ "lynckia/licode" = "$pick" ]; then
    sudo docker pull lynckia/licode
    echo_msg "

MIN_PORT=30000; MAX_PORT=30050; sudo docker run --name licode -p  3000:3000 -p $MIN_PORT-$MAX_PORT:$MIN_PORT-$MAX_PORT/udp -p 3001:3001  -p 8080:8080 -e "MIN_PORT=$MIN_PORT" -e "MAX_PORT=$MAX_PORT" -e "PUBLIC_IP=XX.XX.XX.XX" lynckia/licode

Where the different parameters mean:

      --name is the name of the new container (you can use the name you want)
      -p stablishes a relation between local ports and a container's ports.
         PUBLIC_IP tells Licode the IP that is used to access the server from outside
         MIN_PORT and MAX_PORT defines the udp port range used for webrtc connections.
         Alternatively to the previous two options you can use
         --network="host" to let the container use the dock network and avoid NAT.
      the last param is the name of the image

Once the container is running you can view the console logs using:

    sudo docker logs -f licode

To stop the container:

    sudo docker stop licode

Additionally, if you want to run a single Licode component inside the container you can
select them by appending --mongodb, --rabbitmq, --nuve, --erizoController, --erizoAgent
or --basicExample to the docker run command above.

* Build your own image and run the container from it

You have to git clone Licode's code from GitHub and navigate to docker directory.
There, to compile your own image just run:

    sudo docker build -t licode-image .

    sudo docker images

    Now you can run a new container from the image you have just created with:

    MIN_PORT=30000; MAX_PORT=30050; sudo docker run --name licode -p  3000:3000
    -p $MIN_PORT-$MAX_PORT:$MIN_PORT-$MAX_PORT/udp -p 3001:3001  -p 8080:8080
    -e "MIN_PORT=$MIN_PORT" -e "MAX_PORT=$MAX_PORT" -e "PUBLIC_IP=XX.XX.XX.XX" licode-image
"
else
    echo_err "unsupport image name: $pick"
fi
cd $cmd_dir
exit 0