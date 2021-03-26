FROM debian AS builder
# 用deepin他祖宗debian构建
RUN apt update && apt install -y debootstrap
# 安装debootstrap用于获取deepin的根文件系统
RUN ln -s /usr/share/debootstrap/scripts/buster /usr/share/debootstrap/scripts/apricot && debootstrap --no-check-gpg --arch=amd64 --include=bash apricot /root/rootfs https://community-packages.deepin.com/deepin/
# deepin基于Debian Buster，对debootstrap打补丁以让他可以用于获取deepin的根文件系统
FROM scratch
# 从空镜像开始正式构建
MAINTAINER daze q781000648@qq.com
LABEL maintainer="q781000648@qq.com"
# 署名
COPY --from=builder /root/rootfs /
# 提取rootfs
ADD sources.list /etc/apt/
# 加入sources.list
ENTRYPOINT [ "/bin/bash" ]
# 设置ENTRYPOINT
