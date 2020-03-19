FROM alpine:3.8

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

# Set timezone and locales
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add \
           bash \
           tzdata \
           vim \
           tini \
           su-exec \
           gzip \
           tar \
           wget \
           curl \
    && echo "${TIMEZONE}" > /etc/TZ \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    # Network fix
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

ENV UID=1000 \
    GID=1000 \
    DEBUG_LEVEL=err \
    OSS_ACCESSKEY=aliyun \
    OSS_SECRETKEY=aliyun123 \
    MOUNT_POINT=/mnt/oss \
    OSS_URL=http://oss-cn-hangzhou.aliyuncs.com \
    OSS_REGION=cn-hangzhou \
    OSS_BUCKET=mybucket \
    OSS_KEY=/

RUN apk --no-cache add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev curl bash \
    && wget -qO- https://github.com/aliyun/ossfs/archive/master.tar.gz |tar xz \
    && cd ossfs-master \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && apk del --purge alpine-sdk automake autoconf fuse-dev curl-dev \
    && apk --no-cache add libxml2 libstdc++ \
    && rm -rf /var/cache/apk/* ossfs-master

COPY entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
