FROM golang:1.20-alpine as builder
#go1.22 log-pilot build error

WORKDIR /go/src

RUN \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories && \
    apk update && apk add git

RUN  \
    git clone https://github.com/AliyunContainerService/log-pilot.git && \
    cd log-pilot/ && \
    go mod init && \
    go get && \
    go mod tidy && \
    go mod vendor && \
    CGO_ENABLED=0 go build

ARG TARGETARCH

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai" \
    FILEBEAT_VERSION="8.13.2"

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


ARG TARGETOS
ARG TARGETVARIANT
WORKDIR /go/src
RUN apk add --no-cache git tzdata ca-certificates
RUN git clone https://github.com/elastic/beats.git && cd beats && git checkout v${FILEBEAT_VERSION}
RUN cd beats/filebeat && \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} GOARM=${TARGETVARIANT:1} go build .

COPY install_filebeat.sh /tmp/
RUN /tmp/install_filebeat.sh

FROM slpcat/alpine:3.15
MAINTAINER 若虚 <slpcat@qq.com>

RUN apk update && \ 
    apk add ca-certificates python2 && \
    update-ca-certificates 

RUN mkdir -p /etc/filebeat/prospectors.d/

COPY assets/entrypoint assets/filebeat/ assets/healthz /pilot/
COPY --from=builder /go/src/log-pilot/log-pilot /pilot/pilot
COPY --from=builder /go/src/beats/filebeat/filebeat /usr/bin/filebeat
COPY --from=builder /etc/filebeat/ /etc/filebeat/

HEALTHCHECK CMD /pilot/healthz

VOLUME /var/log/filebeat
VOLUME /var/lib/filebeat

WORKDIR /pilot/
ENV PILOT_TYPE=filebeat
ENTRYPOINT ["/pilot/entrypoint"]
