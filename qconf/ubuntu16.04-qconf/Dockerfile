FROM ubuntu:16.04
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

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog tzdata \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

ARG VERSION=${VERSION:-master}

ENV LOCAL_IDC="test" \
    ZK_LIST="zk-0.zk-svc:2181,zk-1.zk-svc:2181,zk-2.zk-svc:2181"

RUN \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y vim curl wget build-essential cmake \
    && mkdir -p /qconf/tmp \
    && curl -Lk "https://github.com/Qihoo360/QConf/archive/${VERSION}.tar.gz" | \
       tar -xz -C /qconf/tmp --strip-components=1 \
    && cd /qconf/tmp \
    && mkdir build \
    && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/qconf \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install PREFIX=/qconf \
    && rm -rf /qconf/tmp \
    && apt-get remove --purge -y git make g++ autoconf \
    && apt-get autoremove -y \
    && apt-get clean -y

EXPOSE 8888
WORKDIR /qconf
COPY docker-entrypoint.sh /qconf/docker-entrypoint.sh
ENTRYPOINT ["sh", "-c", "/qconf/docker-entrypoint.sh"]
