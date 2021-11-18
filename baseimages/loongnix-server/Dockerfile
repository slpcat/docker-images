# upstream https://github.com/CentOS/sig-cloud-instance-build
FROM slpcat/loongnix-server:8.3-offical

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    #LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

RUN dnf install -y loongnix-release-epel

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

RUN  \
    dnf update -y && \
    dnf clean all

CMD ["/bin/bash"]
