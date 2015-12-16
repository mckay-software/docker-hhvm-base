FROM node:slim
# Using the slim image and installing build deps ourselves
# is a bit more space efficient than using the default image

MAINTAINER McKay Software <opensource@mckaysoftware.co.nz>
CMD ["start-server"]
WORKDIR /app
EXPOSE 80

# HHVM and Node build deps
# (Updates every ~8 weeks)
RUN set -x && export DEBIAN_FRONTEND=noninteractive &&\
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 &&\
    echo 'deb http://dl.hhvm.com/debian jessie main' >> /etc/apt/sources.list &&\
    apt-get update && apt-get install -y binutils bzip2 g++ gcc git hhvm libc-dev make patch python &&\
    update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60 &&\
    apt-get autoremove -y && apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

# Composer and Caddy
# (May update more often)
ADD https://getcomposer.org/composer.phar /opt/
ADD https://caddyserver.com/download/build?os=linux&arch=amd64 /opt/caddy.tgz
RUN set -x; cd /usr/bin && tar xzf /opt/caddy.tgz caddy &&\
    chmod 0755 /opt/composer.phar && rm /opt/caddy.tgz

COPY composer start-server /usr/bin/
COPY Caddyfile server.ini /etc/hhvm/
