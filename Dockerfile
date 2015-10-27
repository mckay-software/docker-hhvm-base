FROM nginx
MAINTAINER McKay Software <opensource@mckaysoftware.co.nz>

ADD https://getcomposer.org/installer /opt/composer-installer.php
ADD https://deb.nodesource.com/setup_4.x /opt/nodesetup.sh
RUN set -x && export DEBIAN_FRONTEND=noninteractive &&\
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 &&\
    echo 'deb http://dl.hhvm.com/debian jessie main' >> /etc/apt/sources.list &&\
    bash /opt/nodesetup.sh && rm /opt/nodesetup.sh &&\
    apt-get install -y hhvm hhvm-dev libpq5 libpq-dev git build-essential nodejs python &&\
    update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60 &&\
    cd /opt && hhvm composer-installer.php &&\
    echo '#!/bin/sh' > /usr/bin/composer &&\
    echo 'hhvm /opt/composer.phar $@' >> /usr/bin/composer &&\
    chmod +x /usr/bin/composer &&\
    rm composer-installer.php &&\
    git clone git://github.com/rny/hhvm-pgsql.git && cd hhvm-pgsql &&\
    git checkout symbol_fix && hphpize && cmake -Wno-dev . && make &&\
    mv pgsql.so /etc/hhvm/ && cd .. && rm -rf hhvm-pgsql &&\
    apt-get autoremove -y hhvm-dev libpq-dev &&\
    apt-get clean &&\
    mkdir -p /app

# Switch back to hhvm-pgsql main repo and branch when it gets fixed for current
# HHVM version: https://github.com/PocketRent/hhvm-pgsql
# Also consider using the Hack-friendly mode: `cmake -DHACK_FRIENDLY=ON .`

CMD ["/start.sh"]
WORKDIR /app

COPY start.sh /
COPY php.ini /etc/hhvm/
COPY nginx.conf /etc/nginx/
