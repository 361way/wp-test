FROM ubuntu:18.04

RUN  apt update \
     && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
     && apt -y install apache2 php php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip php-opcache php-redis mariadb-client php-mysql sendmail\
     && apt clean \
     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
	 
COPY wp src /srv/
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME /var/www/html/
EXPOSE 80

ENTRYPOINT ["/bin/bash","/usr/local/bin/docker-entrypoint.sh"]
