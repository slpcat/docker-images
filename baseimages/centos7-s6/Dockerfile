# upstream https://github.com/CentOS/sig-cloud-instance-build
FROM centos:7

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

ARG TARGETARCH
COPY yum.repos.d/*.repo /etc/yum.repos.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

RUN  \
    yum update -y && \
    yum install -y wget && \
    yum clean all

ARG TARGETARCH
ARG S6_VERSION=v2.2.0.3
ARG SOCKLOG_VERSION=v3.1.1-1
COPY install_s6.sh /tmp

# Install s6-overlay
RUN /tmp/install_s6.sh

## Install socklog-overlay
#ADD https://github.com/just-containers/socklog-overlay/releases/download/${SOCKLOG_VERSION}/socklog-overlay-${TARGETARCH}.tar.gz /tmp/
#RUN tar xzf /tmp/socklog-overlay-${TARGETARCH}.tar.gz -C / && rm /tmp/socklog-overlay-${TARGETARCH}.tar.gz


##
## INIT
##

ENTRYPOINT [ "/init" ]
