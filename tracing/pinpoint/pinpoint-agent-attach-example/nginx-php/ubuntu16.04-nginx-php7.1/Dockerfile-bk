#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/php-nginx:debian-9
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php:debian-8-php7 AS build
MAINTAINER 若虚 <slpcat@qq.com>

ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN echo 'deb http://mirrors.aliyun.com/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny curl locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV WEB_PHP_SOCKET=127.0.0.1:9000

#compile pinpoint-c-agent
#https://github.com/naver/pinpoint-c-agent
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /root
RUN apt-get install -y automake bison flex gcc-4.8 g++-4.8 git libtool libssl-dev make pkg-config \
    && ln -s /usr/bin/gcc-4.8 /usr/bin/gcc \
    && ln -s /usr/bin/gcc-4.8 /usr/bin/cc \
    && ln -s /usr/bin/g++-4.8 /usr/bin/g++
#yum install automake libtool flex bison pkgconfig gcc-c++ make openssl-devel
#yum install php php-devel
RUN git clone https://github.com/naver/pinpoint-c-agent.git \
    && cd pinpoint-c-agent \
    && git checkout master \
    #Build php-agent
    && cd pinpoint_php && bash Build.sh --always-make || bash Build.sh --always-make

FROM webdevops/php:debian-8-php7
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN echo 'deb http://mirrors.aliyun.com/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list \
    && echo 'deb http://nginx.org/packages/debian/ stretch nginx' >> /etc/apt/sources.list

COPY nginx-official-repo.gpg /etc/apt/trusted.gpg.d/

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny curl locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y
ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV WEB_PHP_SOCKET=127.0.0.1:9000

COPY conf/ /opt/docker/

#install pinpoint php module
#COPY --from=build  /root/pinpoint-c-agent/pinpoint_php/modules/pinpoint.so /usr/lib64/php/modules/
COPY --from=build  /root/pinpoint-c-agent/pinpoint_php/modules/pinpoint.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303/
RUN echo 'extension=pinpoint.so' > /opt/docker/etc/php/conf.d/pinpoint.ini \
    && echo 'pinpoint_agent.config_full_name=/etc/pinpoint_agent.conf' >> /etc/php.d/pinpoint.ini

COPY --from=build  /root/pinpoint-c-agent/quickstart/config/pinpoint_agent.conf.example  /etc/pinpoint_agent.conf
#install pinpoint plugins
COPY --from=build  /root/pinpoint-c-agent/quickstart/php/web/plugins/* /app/pinpoint_plugins
#copy sample website source code
COPY --from=build  /root/pinpoint-c-agent/quickstart/php/web/*.php /app

RUN set -x \
    # Install nginx
    && apt-install \
        nginx \
    && docker-run-bootstrap \
    && docker-image-cleanup

EXPOSE 80 443
