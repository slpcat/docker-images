FROM webdevops/php-nginx:debian-8
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

#RUN echo 'deb http://mirrors.aliyun.com/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list \
#    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

ENV \
    APP_ENV="dev" \
    APPLICATION_USER="www-data" \
    APPLICATION_GROUP="www-data" \
    APPLICATION_PATH="/app"

COPY etc /etc/
COPY www_root ${APPLICATION_PATH}/

# System update to latest
# Set timezone
RUN set -x \
    && unlink /etc/nginx/conf.d/10-docker.conf \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && apt-get install -y \
        nginx \
        ca-certificates \
        php5-xdebug \
        php5-dev \
        autoconf \
        make \
        gcc \
    && ln -sf /usr/bin/php5 /usr/bin/php \
    && pecl install yaf-2.3.5 \
    && echo "extension=yaf.so" > /etc/php5/mods-available/yaf.ini \
    && ln -sf /etc/php5/mods-available/yaf.ini /etc/php5/fpm/conf.d/20-yaf.ini \
    && ln -sf /etc/php5/mods-available/yaf.ini /etc/php5/cli/conf.d/20-yaf.ini \
    && docker-image-cleanup
