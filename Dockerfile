FROM nginx
MAINTAINER McKay Software <opensource@mckaysoftware.co.nz>
CMD ["start-server"]
WORKDIR /app
EXPOSE 80

ADD https://getcomposer.org/composer.phar /opt/
ADD https://deb.nodesource.com/setup_5.x /opt/nodesetup.sh
RUN set -x && export DEBIAN_FRONTEND=noninteractive &&\
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 &&\
    echo 'deb http://dl.hhvm.com/debian jessie main' >> /etc/apt/sources.list &&\
    bash /opt/nodesetup.sh && rm /opt/nodesetup.sh &&\
    apt-get install -y binutils bzip2 g++ gcc git hhvm libc-dev make nodejs patch python &&\
    update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60 &&\
    chmod 0755 /opt/composer.phar &&\
    apt-get autoremove -y && apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

COPY composer start-server /usr/bin/
COPY nginx.conf /etc/nginx/
COPY server.ini /etc/hhvm/
