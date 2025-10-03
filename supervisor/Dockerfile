FROM ubuntu:20.04

USER root
RUN apt update && apt install -y supervisor

RUN apt-get update && apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y && apt-get install ca-certificates curl gnupg lsb-release && mkdir -p /etc/apt/keyrings
RUN apt install apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
RUN apt install docker docker-compose -y

RUN echo "docker -H host.docker.internal:4243 \$@" >> /usr/local/bin/proxy_docker && chmod +x /usr/local/bin/proxy_docker

RUN chown www-data:www-data /etc/supervisor/supervisord.conf  \
    && mkdir -p /var/log/supervisor/ \
    && chown -R www-data:www-data /var/log/supervisor/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]