# upstream https://github.com/fedora-cloud/docker-brew-fedora/blob/425644cb22f4f31db65671bb3df75de4ee5b9742/x86_64//Dockerfile
FROM fedora:27

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

RUN  \
    dnf update -y && \
    dnf clean all

CMD ["/bin/bash"]
