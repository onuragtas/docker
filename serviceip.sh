docker run --privileged -p $1:22 --name="$2" -d -e "PASSWORD=$3" -v /sites/$2:/sites -v /sites/$2/.nvm:/root/.nvm --network lemp_net hakanbysal/devenv:latest

sleep 5

ips=$(docker container inspect  $(docker ps --format '{{.Names}} {{.Image}}' |grep devenv |awk '{print $1}') --format '{{.Name}} {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' | sed 's#^/##')
echo "" > /docker/etc/nginx/docker_service_ip.conf
echo "map \$username \$serviceip {" >> /docker/etc/nginx/docker_service_ip.conf
while IFS= read -r line; do
   echo "$line;" >> /docker/etc/nginx/docker_service_ip.conf
done <<< "$ips"
echo "}" >> /docker/etc/nginx/docker_service_ip.conf

sleep 2

localip=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
nginxIp=$(cat global/ip)

docker exec $2 sh -c "echo $2 > /root/username"
docker exec $2 sh -c "echo $localip $2.payment.ept-dev.net >> /etc/hosts"
docker exec $2 sh -c "echo $localip $2.epa-api.ept-dev.net >> /etc/hosts"
docker exec $2 sh -c "echo $localip $2.fe.ept-dev.net >> /etc/hosts"


checkHost=$(cat /etc/hosts |grep $2.payment.ept-dev.net |awk '{print $1}')
if [ "$checkHost" == "" ]; then
echo "127.0.0.1 $2.payment.ept-dev.net"
echo "127.0.0.1 $2.payment.ept-dev.net" >> /etc/hosts
docker exec php74 bash -c "echo $nginxIp $2.payment.ept-dev.net >> /etc/hosts"
docker exec php72 bash -c "echo $nginxIp $2.payment.ept-dev.net >> /etc/hosts"
docker exec php56 bash -c "echo $nginxIp $2.payment.ept-dev.net >> /etc/hosts"
fi

checkHost=$(cat /etc/hosts |grep $2.epa-api.ept-dev.net |awk '{print $1}')
if [ "$checkHost" == "" ]; then
echo "127.0.0.1 $2.epa-api.ept-dev.net"
echo "127.0.0.1 $2.epa-api.ept-dev.net" >> /etc/hosts
docker exec php74 bash -c "echo $nginxIp $2.epa-api.ept-dev.net >> /etc/hosts"
docker exec php72 bash -c "echo $nginxIp $2.epa-api.ept-dev.net >> /etc/hosts"
docker exec php56 bash -c "echo $nginxIp $2.epa-api.ept-dev.net >> /etc/hosts"
fi

checkHost=$(cat /etc/hosts |grep $2.fe.ept-dev.net |awk '{print $1}')
if [ "$checkHost" == "" ]; then
echo "127.0.0.1 $2.fe.ept-dev.net"
echo "127.0.0.1 $2.fe.ept-dev.net" >> /etc/hosts
docker exec php74 bash -c "echo $nginxIp $2.fe.ept-dev.net >> /etc/hosts"
docker exec php72 bash -c "echo $nginxIp $2.fe.ept-dev.net >> /etc/hosts"
docker exec php56 bash -c "echo $nginxIp $2.fe.ept-dev.net >> /etc/hosts"
fi

docker restart global nginx