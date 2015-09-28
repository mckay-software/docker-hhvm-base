FROM nginx
MAINTAINER McKay Software <opensource@mckaysoftware.co.nz>

RUN apt-get update && apt-get install -y curl sudo \
        php5-redis php5-pgsql php5-mysql php5-gd \
        php5-cli php5-fpm php5-curl php5-intl \
        php5-imagick php5-geoip php5-mcrypt &&\
    curl -sS https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/bin/composer &&\
    apt-get remove -y curl &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    rm -r /var/log/nginx &&\
    mkdir -p /var/log/nginx /var/log/php /app &&\
    chown nginx:nginx /app

CMD ["/start.sh"]
WORKDIR /app
EXPOSE 8000

COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php5/fpm/php-fpm.conf
