FROM debian AS builder
MAINTAINER 若虚 <slpcat@qq.com>
# 用deepin他祖宗debian构建
RUN apt update && apt install -y debootstrap
# 安装debootstrap用于获取deepin的根文件系统
RUN ln -s /usr/share/debootstrap/scripts/buster /usr/share/debootstrap/scripts/apricot && debootstrap --no-check-gpg --arch=amd64 --include=bash apricot /root/rootfs https://community-packages.deepin.com/deepin/
# deepin基于Debian Buster，对debootstrap打补丁以让他可以用于获取deepin的根文件系统
FROM scratch
MAINTAINER 若虚 <slpcat@qq.com>

# 从空镜像开始正式构建
COPY --from=builder /root/rootfs /
# 提取rootfs
ADD sources.list /etc/apt/
# 加入sources.list

# Install required packages
RUN \
    apt-get dist-upgrade -y

ARG S6_VERSION=v2.2.0.3
##
## ROOTFS
##

# root filesystem
#COPY rootfs /

# s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz
RUN tar xvfz /tmp/s6-overlay.tar.gz -C /

##
## INIT
##

ENTRYPOINT [ "/init" ]
