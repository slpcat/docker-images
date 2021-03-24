# upstream https://github.com/CentOS/sig-cloud-instance-build
# https://github.com/Yelp/dumb-init
FROM centos:6

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

COPY epel.repo /etc/yum.repos.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

RUN  \
    yum update -y && \
    yum install -y wget openssh-server supervisor && \
    yum clean all

COPY supervisord.conf /etc/supervisord.conf
COPY supervisord.d /etc/supervisord.d

CMD ["/usr/bin/supervisord"]
