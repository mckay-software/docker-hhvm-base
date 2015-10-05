FROM nginx
MAINTAINER McKay Software <opensource@mckaysoftware.co.nz>

ADD https://getcomposer.org/installer /opt/composer-installer.php
RUN set -x && export DEBIAN_FRONTEND=noninteractive &&\
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 &&\
    echo 'deb http://dl.hhvm.com/debian jessie main' >> /etc/apt/sources.list &&\
    apt-get update && apt-get install -y hhvm libpq5 &&\
    cd /opt && hhvm composer-installer.php &&\
    echo '#!/bin/sh' > /usr/bin/composer &&\
    echo 'hhvm /opt/composer.phar $@' >> /usr/bin/composer &&\
    chmod +x /usr/bin/composer &&\
    rm composer-installer.php &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    mkdir -p /app /var/log/docker &&\
    ln -sf /proc/1/fd/1 /var/log/docker/out &&\
    ln -sf /proc/1/fd/2 /var/log/docker/err

CMD ["/start.sh"]
WORKDIR /app

ADD https://cdn.rawgit.com/PocketRent/hhvm-pgsql/4ebbeddc83fae572b4afb9d1a982d6d67f7c8b4a/3.7.0/debian/jessie/pgsql.so /etc/hhvm/

COPY start.sh /
COPY php.ini /etc/hhvm/
COPY nginx.conf /etc/nginx/
