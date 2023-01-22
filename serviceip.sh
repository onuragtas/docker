docker run --privileged -p $1:22 --name="$2" -d -e "PASSWORD=$3" -v /sites/$2:/sites -v /sites/$2/.nvm:/root/.nvm --network lemp_net hakanbysal/devenv:latest

sleep 5

ips=$(docker container inspect  $(docker ps --format '{{.Names}} {{.Image}}' |grep devenv |awk '{print $1}') --format '{{.Name}} {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' | sed 's#^/##')
echo "" > /docker/etc/nginx/docker_service_ip.conf
echo "map \$username \$serviceip {" >> /docker/etc/nginx/docker_service_ip.conf
while IFS= read -r line; do
   echo "$line;" >> /docker/etc/nginx/docker_service_ip.conf
done <<< "$ips"
echo "}" >> /docker/etc/nginx/docker_service_ip.conf

docker restart nginx

sleep 2

docker exec $2 sh -c "echo $2 > /root/username"