FROM elasticsearch:8.18.7

RUN elasticsearch-plugin install analysis-icu || true

ARG HUNSPELL_BASE_URL='https://raw.githubusercontent.com/LibreOffice/dictionaries/master'

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
 && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=https://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install -y hunspell wget

RUN mkdir -p /usr/share/hunspell /usr/share/elasticsearch/config/hunspell \
  && { \
       echo "en_US en/en_US"; \
       echo "tr_TR tr_TR/tr_TR"; \
     } > /tmp/hunspell.txt \
  && cd /usr/share/elasticsearch/config/hunspell \
  && cat /tmp/hunspell.txt | while read line; do \
       name=$(echo $line | awk '{print $1}'); \
       file=$(echo $line | awk '{print $2}'); \
       echo "${HUNSPELL_BASE_URL}/${file}.aff"; \
       mkdir -p "${name}"; \
       wget -O "${name}/${name}.aff" "${HUNSPELL_BASE_URL}/${file}.aff"; \
       wget -O "${name}/${name}.dic" "${HUNSPELL_BASE_URL}/${file}.dic"; \
       ls -al "${name}"; \
       echo -e "strict_affix_parsing: true\nignore_case: true" > ${name}/settings.yml; \
       if [ "${name}" = "cs_CZ" ]; then \
         echo "converting ${name} to UTF-8"; \
         iconv -f ISO-8859-2 -t UTF-8 ${name}/${name}.aff > ${name}/${name}.aff.utf8; \
         sed "1s/ISO8859-2/UTF-8/" ${name}/${name}.aff.utf8 > ${name}/${name}.aff.utf8.1; \
         sed "2119s/$/áéíóúýuerl\]nout/" ${name}/${name}.aff.utf8.1 > ${name}/${name}.aff.utf8; \
         iconv -f ISO-8859-2 -t UTF-8 ${name}/${name}.dic > ${name}/${name}.dic.utf8; \
         rm ${name}/${name}.aff.utf8.1; \
         mv ${name}/${name}.aff.utf8 ${name}/${name}.aff; \
         mv ${name}/${name}.dic.utf8 ${name}/${name}.dic; \
       fi \
     done

RUN ln -s /usr/share/elasticsearch/config/hunspell/cs_CZ/cs_CZ.aff /usr/share/hunspell/default.aff \
  && ln -s /usr/share/elasticsearch/config/hunspell/cs_CZ/cs_CZ.dic /usr/share/hunspell/default.dic

EXPOSE 9200
