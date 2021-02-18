FROM webdevops/php-nginx:ubuntu-18.04 AS builder
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

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
    apt-get dist-upgrade -y \
    && apt-get install -y php-dev libjsoncpp-dev cmake
#make pinpoint_php.so

RUN \
    git clone https://github.com/naver/pinpoint-c-agent.git \
    && cd pinpoint-c-agent/ \
    && phpize \
    && ./configure \
    && make -j2 \
    && make test TESTS=src/PHP/tests/
#result: /pinpoint-c-agent/modules/pinpoint_php.so

FROM webdevops/php-nginx:ubuntu-18.04
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

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
    WEB_PHP_SOCKET=127.0.0.1:9000

COPY conf/* /opt/docker/

ENV AGENT_ID="k8s-php" \
    AGENT_TYPE="PHP" \
    APP_NAME="php-demo" \
    COLLECTOR_IP="pinpoint-collector-headless" \
    COLLECTOR_TCP_PORT="9994" \
    COLLECTOR_STAT_PORT="9995" \
    COLLECTOR_SPAN_PORT="9996" \
    LOGLEVEL="INFO" \
    LOGFILE_ROOTPATH="\/tmp" \
    PLUGIN_ROOTDIR="\/app\/pinpoint_plugins"

#install pinpoint php module
COPY --from=builder /pinpoint-c-agent/modules/pinpoint_php.so /usr/lib/php/20170718/pinpoint_php.so
#COPY 10-pinpoint.sh /opt/docker/provision/entrypoint.d/
COPY pinpoint.ini /etc/php/7.2/mods-available/pinpoint.ini

RUN \
    ln -s /etc/php/7.2/mods-available/pinpoint.ini /etc/php/7.2/fpm/conf.d/pinpoint.ini \
    && ln -s /etc/php/7.2/mods-available/pinpoint.ini /etc/php/7.2/cli/conf.d/pinpoint.ini

#RUN cp /pinpoint-c-agent/quickstart/config/pinpoint_agent.conf.example  /etc/pinpoint_agent.conf
#install pinpoint plugins
#RUN mkdir -p /app/pinpoint_plugins && cp /pinpoint-c-agent/quickstart/php/web/plugins/* /app/pinpoint_plugins
#patch
#RUN wget https://raw.githubusercontent.com/naver/pinpoint-c-agent/master/quickstart/php/web/plugins/curl_plugin.php \
#    && mv curl_plugin.php /app/pinpoint_plugins/
#copy sample website source code
#RUN cp /pinpoint-c-agent/quickstart/php/web/*.php /app
RUN \
    wget -O wordpress.tar.gz  https://cn.wordpress.org/latest-zh_CN.tar.gz \
    && tar -zxf wordpress.tar.gz -C /tmp \
    && mv /tmp/wordpress/* /app/

RUN set -x \
    # Install nginx
    && apt-install \
        nginx \
    && docker-run-bootstrap \
    && docker-image-cleanup

EXPOSE 80 443
