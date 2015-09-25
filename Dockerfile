FROM nginx
MAINTAINER McKay Software <opensource@mckaysoftware.co.nz>

COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN apt-get update && apt-get install -y php5-cli php5-curl curl &&\
    curl -sS https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/bin/composer &&\
    apt-get remove -y curl &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    mkdir /app

WORKDIR /app
USER nginx
