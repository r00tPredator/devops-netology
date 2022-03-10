FROM centos:7
ENV container docker

RUN yum -y install wget;  
RUN yum -y install perl-Digest-SHA;
#RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm"
#RUN yum -y localinstall jdk-17_linux-x64_bin.rpm

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz /; \
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512 ;\
shasum -a 512 -c elasticsearch-8.1.0-linux-x86_64.tar.gz.sha512;

RUN tar -xzf elasticsearch-8.1.0-linux-x86_64.tar.gz;
RUN groupadd elasticsearch && useradd -g elasticsearch elasticsearch
RUN mkdir /var/lib/elasticsearch && cd /var/lib/elasticsearch/ ; mkdir snapsots data work logs;
RUN chown -R elasticsearch:elasticsearch /var/lib/elasticsearch/ ; chown -R elasticsearch:elasticsearch /elasticsearch-8.1.0

RUN rm /elasticsearch-8.1.0-linux-x86_64.tar.gz

ENV ES_HOME="/elasticsearch-8.1.0"
RUN mv ${ES_HOME}/config/elasticsearch.yml ${ES_HOME}/config/elasticsearch.yml.example

RUN echo "node.name: netology_test" > ${ES_HOME}/config/elasticsearch.yml;\
echo "node.roles: master, data" >> ${ES_HOME}/config/elasticsearch.yml; \
echo "path.data: /var/lib/elasticsearch/data/" >> ${ES_HOME}/config/elasticsearch.yml;\
echo "path.logs: /var/lib/elasticsearch/logs/" >> ${ES_HOME}/config/elasticsearch.yml;\
echo "path.repo: /var/lib/elasticsearch/snapsots/ " >> ${ES_HOME}/config/elasticsearch.yml;\
echo "network.host: 0.0.0.0" >> ${ES_HOME}/config/elasticsearch.yml;\
echo 'discovery.seed_hosts: ["127.0.0.1", "[::1]"]' >> ${ES_HOME}/config/elasticsearch.yml; \
echo 'network.publish_host: localhost'  >> ${ES_HOME}/config/elasticsearch.yml; \
echo 'xpack.security.enabled: false' >> ${ES_HOME}/config/elasticsearch.yml

USER elasticsearch
EXPOSE 9200 9300
CMD [ "/elasticsearch-8.1.0/bin/elasticsearch" ]