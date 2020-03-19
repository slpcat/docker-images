FROM gliderlabs/alpine:3.1

MAINTAINER Kazunobu FUJII

ENV INSTALL_DIR=/usr/local \
    LIBEVENT_VERSION=1.4.15-stable \
    BERKELEYDB_VERSION=6.2.23 \
    MEMCACHEQ_VERSION=0.2.0

WORKDIR /tmp

ENV PERSISTENT_DEPS \
    ca-certificates \
    curl \
    tar

RUN apk add -U ${PERSISTENT_DEPS} && \
    rm -rf /var/cache/apk/*

ENV LIBEVENT_DEPS \
    autoconf \
    automake \
    libtool \
    gcc \
    g++ \
    make \
    python

RUN apk add -U ${LIBEVENT_DEPS} && \
    curl -L -o libevent-${LIBEVENT_VERSION}.tar.gz https://github.com/libevent/libevent/archive/release-${LIBEVENT_VERSION}.tar.gz && \
    tar zxf libevent-${LIBEVENT_VERSION}.tar.gz && \
    cd libevent-release-${LIBEVENT_VERSION} && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && make install && \
    apk del --purge ${LIBEVENT_DEPS} && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

ENV BERKELEYDB_DEPS \
    gcc \
    g++ \
    make

RUN apk add -U ${BERKELEYDB_DEPS} && \
    curl -L -o db-${BERKELEYDB_VERSION}.tar.gz http://download.oracle.com/berkeley-db/db-${BERKELEYDB_VERSION}.tar.gz && \
    tar zxf db-${BERKELEYDB_VERSION}.tar.gz && \
    cd db-${BERKELEYDB_VERSION}/build_unix && \
    ../dist/configure --prefix=/usr && \
    make && make install && make uninstall_docs && \
    apk del --purge ${BERKELEYDB_DEPS} && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

ENV MEMCACHEQ_DEPS \
    gcc \
    g++ \
    make

RUN apk add -U ${MEMCACHEQ_DEPS} && \
    curl -L -o memcacheq-${MEMCACHEQ_VERSION}.tar.gz https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-${MEMCACHEQ_VERSION}.tar.gz && \
    tar zxf memcacheq-${MEMCACHEQ_VERSION}.tar.gz && \
    cd memcacheq-${MEMCACHEQ_VERSION} && \
    ./configure --with-bdb=/usr --prefix=${INSTALL_DIR} --enable-threads && \
    make && make install && \
    apk del --purge ${MEMCACHEQ_DEPS} && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

EXPOSE 22201

VOLUME ["/var/lib/memcacheq"]

CMD ["/usr/local/bin/memcacheq","-uroot","-H/var/lib/memcacheq"]

