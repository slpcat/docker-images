FROM slpcat/centos:7

MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    yum update -y && \
    yum install -y python36 && \
    yum clean all

COPY pip.conf /etc/pip.conf
