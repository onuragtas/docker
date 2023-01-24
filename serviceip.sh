localip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
nginxIp=$(cat global/ip)

add_hosts() {
  checkHost=$(cat /sites/$1/.hosts/hosts |grep $1.$2.ept-dev.net |awk '{print $1}')
  if [ "$checkHost" == "" ]; then
  echo "$localip $1.$2.ept-dev.net" >> /sites/$1/.hosts/hosts
  fi
}

mkdir /sites/$2/.hosts -p
touch /sites/$2/.hosts/hosts

docker run --privileged -p $1:22 --name="$2" -d -e "PASSWORD=$3" -v /sites/$2:/sites -v /sites/$2/.nvm:/root/.nvm -v /sites/$2/.hosts/hosts:/etc/hosts -v /docker/etc/nginx/$2:/usr/local/nginx --network lemp_net hakanbysal/devenv:latest

sleep 5

ips=$(docker container inspect  $(docker ps --format '{{.Names}} {{.Image}}' |grep devenv |awk '{print $1}') --format '{{.Name}} {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' | sed 's#^/##')
echo "" > /docker/etc/nginx/docker_service_ip.conf
echo "map \$username \$serviceip {" >> /docker/etc/nginx/docker_service_ip.conf
while IFS= read -r line; do
   echo "$line;" >> /docker/etc/nginx/docker_service_ip.conf
done <<< "$ips"
echo "}" >> /docker/etc/nginx/docker_service_ip.conf

sleep 2

docker exec $2 sh -c "echo $2 > /root/.username"

add_hosts $2 "epa-api"
add_hosts $2 "payment"
add_hosts $2 "fe"
add_hosts $2 "evo-api"
add_hosts $2 "order"
add_hosts $2 "hgs-api"
add_hosts $2 "admin"
add_hosts $2 "evo"

docker restart global nginx