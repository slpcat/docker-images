FROM registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.7-filebeat as builder
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai" \
    FILEBEAT_VERSION="7.10.1"

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

RUN \
    wget  https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
    tar xzvf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64/filebeat /usr/bin/filebeat && \
    rm -rf filebeat-${FILEBEAT_VERSION}-linux-x86_64*

COPY config.filebeat filebeat.tpl /pilot/

FROM slpcat/alpine:3.12
MAINTAINER 若虚 <slpcat@qq.com>

RUN apk update && \ 
    apk add ca-certificates && \
    update-ca-certificates 

COPY --from=builder /pilot/ /pilot/
COPY --from=builder /usr/bin/filebeat /usr/bin/filebeat
COPY --from=builder /etc/filebeat/ /etc/filebeat/

HEALTHCHECK CMD /pilot/healthz

VOLUME /var/log/filebeat
VOLUME /var/lib/filebeat

WORKDIR /pilot/
ENV PILOT_TYPE=filebeat
ENTRYPOINT ["/pilot/entrypoint"]
