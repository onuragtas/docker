FROM ubuntu:20.04
LABEL maintainer="hakanbysl@gmail.com"
ENV version 1.0.0

ENV DEBIAN_FRONTEND noninteractive

# Update and install openssh-server, Docker, Go, PHP 7.4, Java, JDK, Nginx, Node.js, Git, net-tools, htop, telnet, lsof, maven, nano, vim, screen
RUN apt-get update && apt-get install -y openssh-server \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    default-jdk \
    nginx \
    nodejs \
    npm \
    git \
    unzip \
    net-tools \
    htop \
    telnet \
    lsof \
    maven \
    nano \
    vim \
    screen \
    wget \
    cron \
    rsync

RUN apt-get update && apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y && apt-get install ca-certificates curl gnupg lsb-release && mkdir -p /etc/apt/keyrings
RUN apt install apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
RUN apt install docker docker-compose -y

RUN wget https://gist.githubusercontent.com/onuragtas/74f8351c4496598badbd9399814a44a5/raw/ci.sh -O /usr/local/bin/ci.sh
RUN chmod +x /usr/local/bin/ci.sh

RUN wget https://github.com/onuragtas/redock/releases/latest/download/redock_Linux_amd64 -O /usr/local/redock
RUN chmod +x /usr/local/redock
RUN echo "/usr/local/redock" >> /usr/local/bin/redock
RUN chmod +x /usr/local/bin/redock

RUN wget https://gist.githubusercontent.com/onuragtas/c6dddddd6a8e6b8663f4f0043fec052a/raw/eedfc5500af08a04099ad4eb51b5142c996db7fc/go-compiler.sh -O /usr/local/bin/go-compiler.sh -F
RUN chmod +x /usr/local/bin/go-compiler.sh

RUN wget https://github.com/onuragtas/deployment/releases/latest/download/deployment_linux_amd64 -O /usr/local/bin/deployment
RUN chmod +x /usr/local/bin/deployment

RUN wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O /usr/local/go.linux-amd64.tar.gz
RUN tar -vxf /usr/local/go.linux-amd64.tar.gz -C /usr/local/
RUN ln -s /usr/local/go/bin/go /usr/local/bin/go

RUN echo "docker -H 192.168.36.240:4243 exec -w /var/www/html/\$(cat /root/.username)/\$(basename "\$PWD") php84_xdebug \$@" >> /usr/local/bin/php84_container && chmod +x /usr/local/bin/php84_container
RUN echo "docker -H 192.168.36.240:4243 exec -w /var/www/html/\$(cat /root/.username)/\$(basename "\$PWD") php81_xdebug \$@" >> /usr/local/bin/php81_container && chmod +x /usr/local/bin/php81_container
RUN echo "docker -H 192.168.36.240:4243 exec -w /var/www/html/\$(cat /root/.username)/\$(basename "\$PWD") php74_xdebug \$@" >> /usr/local/bin/php74_container && chmod +x /usr/local/bin/php74_container
RUN echo "docker -H 192.168.36.240:4243 exec -w /var/www/html/\$(cat /root/.username)/\$(basename "\$PWD") php72_xdebug \$@" >> /usr/local/bin/php72_container && chmod +x /usr/local/bin/php72_container
RUN echo "docker -H 192.168.36.240:4243 exec -w /var/www/html/\$(cat /root/.username)/\$(basename "\$PWD") php56_xdebug \$@" >> /usr/local/bin/php56_container && chmod +x /usr/local/bin/php56_container
RUN echo "docker -H 192.168.36.240:4243 exec postgres \$@" >> /usr/local/bin/postgres_container && chmod +x /usr/local/bin/postgres_container
RUN echo "docker -H 192.168.36.240:4243 exec mongo \$@" >> /usr/local/bin/mongo_container && chmod +x /usr/local/bin/mongo_container
RUN echo "docker -H 192.168.36.240:4243 exec db \$@" >> /usr/local/bin/mysql_container && chmod +x /usr/local/bin/mysql_container
RUN echo "docker -H 192.168.36.240:4243 exec nginx \$@" >> /usr/local/bin/nginx_container && chmod +x /usr/local/bin/nginx_container

ENV PASSWORD=password

RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin\ yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication.*/PasswordAuthentication\ yes/' /etc/ssh/sshd_config

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm"
RUN . $HOME/.nvm/nvm.sh

#RUN wget https://raw.githubusercontent.com/wayneeseguin/rvm/master/binscripts/rvm-installer -O /usr/local/bin/rvm-installer
#RUN chmod +x /usr/local/bin/rvm-installer
#RUN /usr/local/bin/rvm-installer
#RUN #source /etc/profile.d/rvm.sh
#RUN /usr/local/rvm/bin/rvm install 3.2.2

EXPOSE 22 80 443 8090 9000 9001 9002 9003 9004 9005 9006 9007 9008 9010

RUN mkdir /sites
WORKDIR /sites

COPY redock-service.sh /usr/local/bin/redock-service.sh
COPY startup.sh /usr/local/bin/startup.sh

RUN chmod +x /usr/local/bin/redock-service.sh && \
    chmod +x /usr/local/bin/startup.sh

CMD ["/usr/local/bin/startup.sh"]