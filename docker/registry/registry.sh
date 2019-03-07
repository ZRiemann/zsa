#!/bin/bash

domain=$(hostname)
user=guest
password=guest
echo "domain: ${domain}"

# docker pull registry:2

rm -fr certs auth registry /etc/docker/certs.d/${domain}:5000
mkdir -p certs auth registry /etc/docker/certs.d/${domain}:5000

echo "Common Name MAST BE: ${domain}"
openssl req \
        -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
        -x509 -days 999 -out certs/domain.crt

docker run \
       --entrypoint htpasswd \
       registry:2 -Bbn ${user} ${password} > auth/htpasswd

cp certs/domain.crt /etc/docker/certs.d/${domain}:5000
cp certs/domain.crt /usr/local/share/ca-certificates/${domain}.crt
update-ca-certificates

echo "make sure
/etc/docker/daemon.json append item:
\"insecure-registries\" : [\"${domain}:5000\"]

Pess any key to continue...
"
read pick

echo "stop container registry"
docker container stop registry
echo "remove container registry"
docker container rm -v registry
echo "restart docker"
systemctl restart docker



docker run -d \
       -p 5000:5000 \
       --restart=always \
       --name registry \
       -v "$(pwd)"/auth:/auth \
       -e REGISTRY_AUTH=htpasswd \
       -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
       -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
       -v "$(pwd)"/certs:/certs \
       -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
       -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
       -v "$(pwd)"/registry:/var/lib/registry \
       registry:2


echo "
usage:
  $ docker login ${domain}:5000
    ${user}
    ${password}
  $ docker tag ubuntu ${domain}:5000/ubuntu
  $ docker push ${domain}:5000

on other hosts, copy the certs/domain.crt 
  cp certs/domain.crt /etc/docker/certs.d/${domain}:5000
  cp certs/domain.crt /usr/local/share/ca-certificates/${domain}.crt
  update-ca-certificates
"