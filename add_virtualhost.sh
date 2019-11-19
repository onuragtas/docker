found_in_hosts() {
  hosts_count=$(cat /etc/hosts | wc -l)
  for n in $(seq 1 $hosts_count); do
    line=$(cat /etc/hosts | grep '' | sed -n "${n}p")
    line="${line:0:1}"
    if [ "$line" != "#" ]; then
      hostsdomain=$(cat /etc/hosts | grep '' | awk '{print $2}' | sed -n "${n}p")
      ip=$(cat /etc/hosts | grep '' | awk '{print $1}' | sed -n "${n}p")
      if [ "$hostsdomain" != "" ] && [ "$hostsdomain" == "$1" ]; then
        echo "true"
        return
      fi
    fi
  done
  echo "false"
  return
}

is_exists_conf() {
  find=$(ls $1 | grep $2)
  if [ "$find" == "" ]; then
    echo "false"
    return
  else
    echo "true"
    return
  fi
}

read -p "type (nginx or apache2): " type
read -p "domain: " domain

if [ "$type" == "nginx" ]; then
  if [ "$(is_exists_conf "etc/nginx" $domain)" == "true" ]; then
    read -p "this conf is exists. Continue? (y/n/c): " confcontinue
    if [ "$confcontinue" == "n" ]; then
      read -p "domain: " domain
      while [ true ]; do
        if [ "$(is_exists_conf "etc/nginx" $domain)" == "false" ]; then
          break
        else
          read -p "$domain exists, domain: " domain
        fi
      done
    elif [ "$confcontinue" == "c" ]; then
      exit 1
    fi
  fi
elif [ "$type" == "apache2" ]; then
  if [ "$(is_exists_conf "httpd/sites-enabled" $domain)" == "true" ]; then
    read -p "this conf is exists. Continue? (y/n/c): " confcontinue
    if [ "$confcontinue" == "n" ]; then
      read -p "domain: " domain
      while [ true ]; do
        if [ "$(is_exists_conf "httpd/sites-enabled" $domain)" == "false" ]; then
          break
        else
          read -p "$domain exists, domain: " domain
        fi
      done
    elif [ "$confcontinue" == "c" ]; then
      exit 1
    fi
  fi
else
  exit 1
fi

if [ "$(found_in_hosts $domain)" == "true" ]; then
  echo "$ip $domain exists in /etc/hosts"
  while [ true ]; do
    read -p "continue ? (y/n/c): " continue
    if [ $continue == "y" ]; then
      echo "contining..."
      break
    elif [ $continue == "n" ]; then
      while [ true ]; do
        read -p "domain: " domain
        if [ "$(found_in_hosts $domain)" == "false" ]; then
          existok=true
          break
        else
          echo "$domain too exists"
        fi
      done
      if [ $existok == true ]; then
        break
      fi
    else
      exit 1
    fi
  done

fi

read -p "folder: " folder
read -p "phpversion: " phpversion

if [ $type == "nginx" ]; then
  echo "server {
    server_name $domain;
    root /var/www/html/$folder;
    index index.html index.php;

    location / {
        index index.php;
        # Check if a file or directory index file exists, else route it to
        try_files \$uri \$uri/ /index.php;
    }

    # set expiration of assets to MAX for caching
    location ~* \.(ico|css|js|gif)(\?[0-9]+)?$ {
        expires max;
        log_not_found off;
    }

    location ~* \.php$ {
        fastcgi_pass $phpversion:9000;
        include fastcgi.conf;
    }

    location ~ /files {
        deny all;
        return 404;
    }
}" >etc/nginx/$domain.conf
fi

if [ $type == "apache2" ]; then
  apache2host=$(cat .env | grep "APACHE_HOST")
  apache2host="${apache2host//APACHE_HOST=/}"
  echo "<VirtualHost *:80>
    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://$phpversion:9000/var/www/html/$folder/\$1
    DirectoryIndex /index.php index.php
	ServerName $domain
	DocumentRoot /var/www/html/$folder
	LogLevel info
	<Directory /var/www/html/$folder>
        DirectoryIndex index.php
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
     </Directory>
</VirtualHost>" >httpd/sites-enabled/$domain.conf

  echo "server {
    listen 80;
    server_name $domain;
    location / {
        proxy_pass http://$apache2host:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}" >etc/nginx/$domain.conf
fi

if [ "$(found_in_hosts $domain)" == "false" ]; then
  echo "adding /etc/hosts"
  sudo sh -c 'echo "127.0.0.1 '$domain'" >> /etc/hosts'
fi

if [ "$type" == "nginx" ]; then
  docker-compose restart nginx
else
  docker-compose restart httpd
  docker-compose restart nginx
fi
