#upstream https://github.com/gcavalcante8808/docker-mydumper
FROM alpine:3.8 as builder
ARG MAJOR_VERSION=0.9
ARG MINOR_VERSION=5
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories
RUN apk add --no-cache gcc g++ mysql-dev ca-certificates openssl wget glib-dev cmake && \
    mkdir -p /usr/src/mydumper
WORKDIR /usr/src/
RUN apk add --no-cache make
RUN wget https://github.com/maxbube/mydumper/archive/v${MAJOR_VERSION}.${MINOR_VERSION}.tar.gz && \
    #wget https://launchpad.net/mydumper/${MAJOR_VERSION}/${MAJOR_VERSION}.${MINOR_VERSION}/+download/mydumper-${MAJOR_VERSION}.${MINOR_VERSION}.tar.gz && \
    tar xzvf v${MAJOR_VERSION}.${MINOR_VERSION}.tar.gz -C /usr/src/mydumper --strip-components 1 && \
    rm v${MAJOR_VERSION}.${MINOR_VERSION}.tar.gz
RUN cd mydumper && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j

FROM alpine:3.8
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

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories
RUN apk add --no-cache mysql-client mariadb-connector-c glib bash
COPY --from=builder /usr/src/mydumper/mydumper /usr/src/mydumper/myloader /usr/bin/

COPY docker-entrypoint.sh /entrypoint
#ENTRYPOINT ["bash","-x","/entrypoint"]
CMD ["bash","-x","/entrypoint"]
