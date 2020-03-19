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
    AWS_ACCESSKEY=minio \
    AWS_SECRETKEY=minio123 \
    MOUNT_POINT=/mnt/s3 \
    S3_URL=http://minio:9000 \
    S3_REGION=us-east-1 \
    S3_BUCKET=mybucket \
    S3_KEY=/

RUN apk --no-cache add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev curl git bash && \
    git clone https://github.com/s3fs-fuse/s3fs-fuse.git /tmp/s3fs && \
    cd /tmp/s3fs && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    apk del --purge alpine-sdk automake autoconf fuse-dev curl-dev git && \
    apk --no-cache add libxml2 libstdc++ && \
    rm -rf /tmp/*

COPY entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
