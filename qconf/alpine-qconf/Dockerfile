FROM alpine:3.8 AS builder
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

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
           wget \
           curl \
    && echo "${TIMEZONE}" > /etc/TZ \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    # Network fix
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

ARG VERSION=${VERSION:-master}

RUN apk add --no-cache --virtual .build-deps \
      curl gcc g++ make cmake autoconf libc-dev bsd-compat-headers patch libevent-dev linux-headers perl tar \
    && mkdir -p /qconf/tmp \
    && curl -Lk "https://github.com/Qihoo360/QConf/archive/${VERSION}.tar.gz" | \
       tar -xz -C /qconf/tmp --strip-components=1 \
    && cd /qconf/tmp \
    && sed -i '/cmake_minimum_required/aSET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")\nSET(BUILD_SHARED_LIBS OFF)\nSET(CMAKE_EXE_LINKER_FLAGS "-static -pthread -lrt -ldl")' CMakeLists.txt \
    && mkdir build \
    && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/opt/qconf \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install PREFIX=/opt/qconf \
    && rm -rf /qconf/tmp \
    && apk add --virtual .rundeps libstdc++ \
    && apk del .build-deps

FROM alpine:3.8 
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

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
           wget \
           curl \
    && echo "${TIMEZONE}" > /etc/TZ \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    # Network fix
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

COPY --from=builder /opt /opt
WORKDIR /opt/qconf
COPY docker-entrypoint.sh docker-entrypoint.sh
CMD ["sh", "-c", "docker-entrypoint.sh"]
