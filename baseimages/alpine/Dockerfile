# Build a minimal distribution container
# upstream https://github.com/gliderlabs/docker-alpine
FROM alpine:3.19
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

# Set timezone and locales
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add \
           bash \
           gcompat \
           tzdata ca-certificates \
           vim \
           tini \
           su-exec \
           gzip \
           tar \
           wget \
           curl \
           binutils \
           ethtool \
           net-tools \
           iproute2 \
           procps \
           inetutils-telnet \
           less \
           git \
           tcpdump \
           musl-locales \
           musl-locales-lang \
           lang \
           grep \
           util-linux findutils readline lsof \

    && echo "${TZ}" > /etc/TZ \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    # Network fix
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

CMD ["/bin/bash"]
