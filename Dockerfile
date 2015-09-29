FROM nginx
MAINTAINER McKay Software <opensource@mckaysoftware.co.nz>

ADD https://getcomposer.org/installer /opt/composer-installer.php
RUN set -x && export DEBIAN_FRONTEND=noninteractive &&\
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 &&\
    echo 'deb http://dl.hhvm.com/debian jessie main' >> /etc/apt/sources.list &&\
    apt-get update && apt-get install -y hhvm &&\
    cd /opt && hhvm composer-installer.php &&\
    echo '#!/bin/sh' > /usr/bin/composer &&\
    echo 'hhvm /opt/composer.phar $@' >> /usr/bin/composer &&\
    chmod +x /usr/bin/composer &&\
    rm composer-installer.php &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    rm -r /var/log/nginx &&\
    mkdir -p /var/log/nginx /app

CMD ["/start.sh"]
WORKDIR /app

COPY start.sh /
COPY php.ini /etc/hhvm/
COPY nginx.conf /etc/nginx/
