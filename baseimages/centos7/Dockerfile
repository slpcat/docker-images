# upstream https://github.com/CentOS/sig-cloud-instance-build
FROM centos:7

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm-256color" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

COPY yum.repos.d/*.repo /etc/yum.repos.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

RUN  \
    yum update -y && \
    yum install -y net-tools iproute curl wget traceroute tcpdump nc telnet git && \
    yum clean all

CMD ["/bin/bash"]
