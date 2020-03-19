#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/php-nginx:debian-9
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php:centos-7-php7
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

#COPY nginx.repo /etc/yum.repos.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

RUN  \
    sed -i s/https/http/  /etc/yum.repos.d/webtatic.repo && \
    for pkg in `rpm -qa|grep php`; do yum remove -y  $pkg; done && \
    rm -f /etc/php.d/00-ioncube.ini && \
    yum update -y && \
    yum clean all && \

    yum install -y file php71w php71w-cli php71w-pear php71w-pgsql php71w-pecl-imagick \
        php71w-mbstring php71w-opcache php71w-fpm php71w-pecl-redis php71w-mysqlnd \
        php71w-pecl-memcached php71w-pecl-mongodb php71w-gd php71w-gmp php71w-soap \
        php71w-mcrypt php71w-ldap php71w-devel librdkafka librdkafka-devel gcc make

RUN  \
    git clone https://github.com/arnaud-lb/php-rdkafka.git && \
    cd php-rdkafka && git checkout 3.0.5 && \
    phpize && \
    ./configure && \
    make && \
    cp modules/rdkafka.so /usr/lib64/php/modules/rdkafka.so && \
    echo "extension=rdkafka.so" > /etc/php.d/rdkafka.ini && \
    pecl install msgpack && \
    echo "extension=msgpack.so" > /etc/php.d/msgpack.ini && \
    pecl install jsond && \
    echo "extension=jsond.so" > /etc/php.d/jsond.ini && \
    cd .. && rm -rf php-rdkafka 

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET="" \
    WEB_PHP_SOCKET=127.0.0.1:9000

COPY conf/ /opt/docker/

RUN set -x \
    # Install nginx
    && yum install -y \
        nginx \
    && docker-run-bootstrap \
    && docker-image-cleanup \
    && mkdir -p /var/log/php-fpm && touch /var/log/php-fpm/error.log
RUN yum install cyrus-sasl-plain cyrus-sasl cyrus-sasl-devel cyrus-sasl-lib

RUN \
    sed -i '/memcached.use_sasl/a\memcached.use_sasl = 1' /etc/php.d/z-memcached.ini &&\
    sed -i 's/priority=20/priority=25/' /opt/docker/etc/supervisor.d/nginx.conf

EXPOSE 80 443
