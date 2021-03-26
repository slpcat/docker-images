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
    apt-get dist-upgrade -y \
    && apt-get install -y python3 python3-pip curl ca-certificates lsb-release\
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && composer selfupdate

#install nginx
#RUN \
    #echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx"     | tee /etc/apt/sources.list.d/nginx.list \
    #&& echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n"  | tee /etc/apt/preferences.d/99nginx \
    #&& curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key \
    #&& gpg --dry-run --quiet --import --import-options show-only /tmp/nginx_signing.key \
    #&& mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc \
    #&& rm -f /etc/nginx/nginx.conf \
    #&& apt-get update -y \
    #&& apt-get install -y nginx 

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=127.0.0.1:9000

COPY conf/ /opt/docker/
COPY php.ini /etc/php/7.2/fpm/php.ini

ENV AGENT_ID="k8s-php" \
    AGENT_TYPE="PHP" \
    APP_NAME="php-demo" \
    COLLECTOR_CONFIG=/opt/pinpoint-collector-agent/conf/collector.conf \
    # pinpoint collector span ip
    PP_COLLECTOR_AGENT_SPAN_IP=pinpoint-collector \
    # pinpoint collector span port
    PP_COLLECTOR_AGENT_SPAN_PORT=9993 \
    # pinpoint collector agent IP
    PP_COLLECTOR_AGENT_AGENT_IP=pinpoint-collector \
    # pinpoint collector agent port
    PP_COLLECTOR_AGENT_AGENT_PORT=9991 \
    # pinpoint collector stat ip
    PP_COLLECTOR_AGENT_STAT_IP=pinpoint-collector \
    # pinpoint collector stat port
    PP_COLLECTOR_AGENT_STAT_PORT=9992 \
    # mark all agent a docker
    PP_COLLECTOR_AGENT_ISDOCKER=true \
    PP_LOG_DIR=/tmp/ \
    PP_Log_Level=ERROR

#install pinpoint-collector-agent
COPY --from=builder /pinpoint-c-agent/collector-agent /opt/pinpoint-collector-agent
COPY init_python_env.sh /opt/pinpoint-collector-agent/init_python_env.sh
RUN \
    cd /opt/pinpoint-collector-agent \
    && pip3 install -r requirements.txt \
    && bash -x init_python_env.sh

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
    && docker-run-bootstrap \
    && docker-image-cleanup

EXPOSE 80
