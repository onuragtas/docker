FROM debian:12

# Hash mismatch problemini kes
RUN echo 'Acquire::By-Hash "no";' > /etc/apt/apt.conf.d/99no-by-hash

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    apt-get update -o Acquire::Retries=5 && \
    apt-get install -y --no-install-recommends \
        apache2 \
        nano unzip wget curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Apache modülleri
RUN a2enmod proxy_http rewrite proxy_fcgi headers vhost_alias

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
