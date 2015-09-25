FROM nginx
MAINTAINER McKay Software <opensource@mckaysoftware.co.nz>

RUN apt-get update && apt-get install -y curl \
        php5-redis php5-pgsql php5-mysql php5-gd \
        php5-cli php5-fpm php5-curl php5-intl \
        php5-imagick php5-geoip php5-mcrypt &&\
    curl -sS https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/bin/composer &&\
    apt-get remove -y curl &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    mkdir /app &&\
    chown nginx:nginx /app &&\
    chmod +x /start.sh

CMD ["/start.sh"]
WORKDIR /app

COPY start.sh /start.sh
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY php-fpm.conf /etc/php5/fpm/php-fpm.conf

USER nginx
