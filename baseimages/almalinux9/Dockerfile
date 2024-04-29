# upstream https://github.com/CentOS/sig-cloud-instance-build
FROM almalinux:9

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
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^# baseurl=https://repo.almalinux.org|baseurl=https://mirrors.aliyun.com|g' \
      -i.bak \
      /etc/yum.repos.d/almalinux*.repo && \
    yum update -y && \
    yum install -y ethtool net-tools procps-ng iproute wget traceroute tcpdump nc telnet git && \
    yum clean all

CMD ["/bin/bash"]
