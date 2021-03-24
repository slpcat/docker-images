# upstream https://github.com/CentOS/sig-cloud-instance-build
FROM centos:8

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    #LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

COPY yum.repos.d/*.repo /etc/yum.repos.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

RUN \
    cd /etc/yum.repos.d \
    && sed -i 's/mirrorlist=/#mirrorlist=/g' CentOS-Base.repo CentOS-AppStream.repo CentOS-Extras.repo \ 
    && sed -i 's/#baseurl=/baseurl=/g' CentOS-Base.repo CentOS-AppStream.repo CentOS-Extras.repo \
    && sed -i 's/http:\/\/mirror.centos.org/https:\/\/mirrors.aliyun.com/g' CentOS-Base.repo CentOS-AppStream.repo CentOS-Extras.repo

RUN  \
    dnf update -y && \
    dnf clean all

CMD ["/bin/bash"]
