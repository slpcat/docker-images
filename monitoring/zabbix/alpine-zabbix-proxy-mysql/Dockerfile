# Build a minimal distribution container
# upstream https://github.com/zabbix/zabbix-docker
FROM zabbix/zabbix-proxy-mysql:alpine-7.0.12
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="zh_CN.UTF-8" \ 
    LANGUAGE="zh_CN.UTF-8" \
    LC_ALL="zh_CN.UTF-8" \
    TIMEZONE="Asia/Shanghai"

USER root

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

COPY pip.conf /etc/pip.conf

# Set timezone and locales
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add \
           bash \
           tzdata \
           vim \
           tini \
           su-exec \
           gzip \
           tar \
           python3 \
           py3-pip \
           py3-requests \
           wget \
           openssh \
           curl \
    && echo "${TIMEZONE}" > /etc/TZ \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    # Network fix
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

COPY ssh_config /etc/ssh/ssh_config

USER zabbix
