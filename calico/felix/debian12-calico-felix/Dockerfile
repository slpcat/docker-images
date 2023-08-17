FROM golang:1.20-bookworm as builder

WORKDIR /go/src

RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y  wget git  docker.io

RUN  \
    git clone https://github.com/projectcalico/calico.git && \
cd calico
git checkout v3.26.1

cd felix

    cd log-pilot/ && \
    go mod init && \
    go get && \
    go mod tidy && \
    go mod vendor && \
    go build

ARG TARGETARCH

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai" \
    FILEBEAT_VERSION="8.3.2"

COPY install_filebeat.sh /tmp/
RUN /tmp/install_filebeat.sh

FROM slpcat/debian:bullseye
MAINTAINER 若虚 <slpcat@qq.com>

RUN \ 
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y python2 procps && \
    update-alternatives --install /usr/bin/python python /usr/bin/python2.7 0

RUN mkdir -p /etc/filebeat/prospectors.d/

COPY assets/entrypoint assets/filebeat/ assets/healthz /pilot/
COPY --from=builder /go/src/log-pilot/log-pilot /pilot/pilot
COPY --from=builder /usr/bin/filebeat /usr/bin/filebeat
COPY --from=builder /etc/filebeat/ /etc/filebeat/

HEALTHCHECK CMD /pilot/healthz

VOLUME /var/log/filebeat
VOLUME /var/lib/filebeat

WORKDIR /pilot/
ENV PILOT_TYPE=filebeat
ENTRYPOINT ["/pilot/entrypoint"]
