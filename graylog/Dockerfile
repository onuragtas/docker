FROM ubuntu:latest

RUN apt-get update && apt-get install -y apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen gnupg2 gnupg gnupg1 wget

RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -

#RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

RUN apt-get install -y mongodb-server

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

RUN echo "deb https://artifacts.elastic.co/packages/oss-6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list

#RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2-amd64.deb
#RUN dpkg -i elasticsearch-6.3.2-amd64.deb
RUN apt-get update && apt-get install -y elasticsearch-oss


RUN wget https://packages.graylog2.org/repo/packages/graylog-3.1-repository_latest.deb

RUN dpkg -i graylog-3.1-repository_latest.deb && apt-get update && apt-get install -y graylog-server

#RUN service mongodb start
#RUN service elasticsearch start
#RUN service graylog-server start
#RUN graylog-server

EXPOSE 9000

COPY ./docker-entrypoint.sh .
RUN ["chmod", "+x", "./docker-entrypoint.sh"]
RUN sh ./docker-entrypoint.sh