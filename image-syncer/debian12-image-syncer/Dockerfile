FROM slpcat/debian:bookworm

LABEL org.opencontainers.image.authors="slpcat@qq.com"

ARG VERSION=v1.5.5

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    rm -rf /var/lib/apt/lists/

RUN cd /tmp && \
    wget https://github.com/AliyunContainerService/image-syncer/releases/download/$VERSION/image-syncer-$VERSION-linux-amd64.tar.gz && \
    tar -zxf image-syncer-$VERSION-linux-amd64.tar.gz && \
    mv image-syncer /usr/local/bin && \
    rm -rf /tmp/*
