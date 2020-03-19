#upstream https://github.com/kubernetes-incubator/external-storage/blob/master/ceph/rbd/Dockerfile
FROM slpcat/golang-gvm AS builder
MAINTAINER 若虚 <slpcat@qq.com>

#get source code
RUN git clone https://github.com/kubernetes-incubator/external-storage.git \
    && cd external-storage \
    && git checkout rbd-provisioner-v1.1.0-k8s1.10
COPY go_build.sh /go_build.sh
RUN /go_build.sh

FROM ubuntu:16.04
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai" \
    CEPH_VERSION="mimic"

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

# install ceph client
COPY ceph.gpg /etc/apt/trusted.gpg.d/ceph.gpg

RUN \
    echo "deb http://mirrors.aliyun.com/ceph/debian-${CEPH_VERSION}/ xenial main" >> /etc/apt/sources.list \
    && apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ceph-common

COPY --from=builder /rbd-provisioner /usr/local/bin/rbd-provisioner
ENTRYPOINT ["/usr/local/bin/rbd-provisioner"]
