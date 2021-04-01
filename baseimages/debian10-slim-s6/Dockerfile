#upstream https://github.com/debuerreotype/docker-debian-artifacts/blob/de09dd55b6328b37b89a33e76b698f9dbe611fab/jessie/backports/Dockerfile
FROM debian:buster-slim
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

RUN echo 'deb http://mirrors.aliyun.com/debian buster-backports main' > /etc/apt/sources.list.d/backports.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny curl locales \ 
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y  wget && \
    rm -rf /var/lib/apt/lists/

ARG S6_VERSION=v2.2.0.3
ARG SOCKLOG_VERSION=v3.1.1-1
##
## ROOTFS
##

# root filesystem
#COPY rootfs /

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${TARGETARCH}.tar.gz /tmp/s6-overlay.tar.gz
RUN tar xvfz /tmp/s6-overlay.tar.gz -C / && rm /tmp/s6-overlay.tar.gz

## Install socklog-overlay
#ADD https://github.com/just-containers/socklog-overlay/releases/download/${SOCKLOG_VERSION}/socklog-overlay-${TARGETARCH}.tar.gz /tmp/
#RUN tar xzf /tmp/socklog-overlay-${TARGETARCH}.tar.gz -C / && rm /tmp/socklog-overlay-${TARGETARCH}.tar.gz

##
## INIT
##

ENTRYPOINT [ "/init" ]
