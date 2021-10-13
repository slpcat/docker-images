FROM golang:1.17-bullseye as builder

WORKDIR /go/src

RUN echo 'deb http://mirrors.aliyun.com/debian bullseye-backports main' > /etc/apt/sources.list.d/backports.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list

RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y  wget git

RUN  \
    git clone https://github.com/AliyunContainerService/log-pilot.git && \
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
    FILEBEAT_VERSION="7.15.0"

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
