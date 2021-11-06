# Build a minimal distribution container
# upstream https://github.com/gliderlabs/docker-alpine
FROM zabbix/zabbix-web-nginx-pgsql:5.4-ubuntu-latest
MAINTAINER 若虚 <slpcat@qq.com>


# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

USER root

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

RUN \
    apt-get install -y php php-opcache

#COPY wqy-microhei.ttf /usr/share/zabbix/fonts/
COPY wqy-microhei.ttf /usr/share/zabbix/assets/fonts/
COPY php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
COPY 99-zabbix.ini 10-opcache.ini /etc/php/7.4/fpm/conf.d/
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-site.conf /etc/nginx/conf.d/nginx.conf

RUN sed -i s/DejaVuSans/wqy-microhei/g  /usr/share/zabbix/include/defines.inc.php && \
    mkdir -p /var/cache/nginx/client_temp && \
    chown zabbix:zabbix /var/cache/nginx

USER zabbix
