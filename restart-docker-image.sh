docker pull hakanbysal/devenv:latest
ips=$(docker container inspect  $(docker ps --format '{{.Names}} {{.Image}}' |grep devenv |awk '{print $1}') --format '{{.Name}}' | sed 's#^/##')

while IFS= read -r username; do
   password_cmd=$(docker container inspect $username --format='{{index (index (.Config.Env)) 0 }}')
   IFS='='
   read -a strarr <<< "$password_cmd"
   password=${strarr[1]}

   port=$(docker container inspect $username --format '{{ (index (index .NetworkSettings.Ports "22/tcp") 0).HostPort }}')
   echo "docker rm $username -f && bash /docker/serviceip.sh $port $username $password"
   docker rm $username -f && bash /docker/serviceip.sh $port $username $password
done <<< "$ips"
