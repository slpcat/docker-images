FROM slpcat/debian:stretch-systemd
MAINTAINER 若虚 <slpcat@qq.com>

RUN apt-get install -y gnupg2

# Install packages https://fai-project.org/download/
RUN curl --silent http://fai-project.org/download/074BCDE4.asc | \
      apt-key --keyring /etc/apt/trusted.gpg.d/fai-keyring.gpg add - && \
    echo "deb http://fai-project.org/download stretch koeln" > \
      /etc/apt/sources.list.d/fai.list && \
    apt-get update  -qq && \
    apt-get upgrade -qq -y && \
    apt-get install -qq -y \
      fai-server syslinux nfs-ganesha  apt-cacher-ng nginx && \
    apt-get clean all

#use configs and linux images from slpcat
WORKDIR /root
RUN \
git clone https://github.com/slpcat/fai_config

#change apt-cacher-ng config
COPY acng.conf /etc/apt-cacher-ng/acng.conf

VOLUME [ "/srv", "/tmp" ]
