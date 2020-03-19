FROM ceph/daemon:latest-mimic

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

RUN  \
    yum update -y && \
    yum install -y iproute dpdk && \
    yum clean all
