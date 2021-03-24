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
    yum install -y wget openssh-server && \
    yum clean all

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/local/bin/dumb-init

# Runs "/usr/local/bin/dumb-init -- /my/script --with --args"
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["/etc/init.d/sshd", "start"]
