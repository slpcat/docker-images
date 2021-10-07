FROM alpine:3.12 as rootfs-stage

# environment
ENV REL=focal
ARG TARGETARCH
# install packages
RUN \
 apk add --no-cache \
        bash \
        curl \
        tzdata \
        xz

# grab base tarball
RUN \
 mkdir /root-out && \
 curl -o \
	/rootfs.tar.gz -L \
	https://partner-images.canonical.com/core/${REL}/current/ubuntu-${REL}-core-cloudimg-${TARGETARCH}-root.tar.gz && \
 tar xf \
        /rootfs.tar.gz -C \
        /root-out

# Runtime stage
FROM scratch
COPY --from=rootfs-stage /root-out/ /
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheLamer"

COPY patch/ /tmp/patch

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/root" \
LANGUAGE="en_US.UTF-8" \
LANG="en_US.UTF-8" \
TERM="xterm"

# copy sources
COPY sources.list /etc/apt/

ARG TARGETARCH
ARG S6_VERSION=v2.2.0.3
ARG SOCKLOG_VERSION=v3.1.1-1
COPY install_s6.sh /tmp

RUN \
 echo "**** Ripped from Ubuntu Docker Logic ****" && \
 set -xe && \
 echo '#!/bin/sh' \
	> /usr/sbin/policy-rc.d && \
 echo 'exit 101' \
	>> /usr/sbin/policy-rc.d && \
 chmod +x \
	/usr/sbin/policy-rc.d && \
 dpkg-divert --local --rename --add /sbin/initctl && \
 cp -a \
	/usr/sbin/policy-rc.d \
	/sbin/initctl && \
 sed -i \
	's/^exit.*/exit 0/' \
	/sbin/initctl && \
 echo 'force-unsafe-io' \
	> /etc/dpkg/dpkg.cfg.d/docker-apt-speedup && \
 echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' \
	> /etc/apt/apt.conf.d/docker-clean && \
 echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' \
	>> /etc/apt/apt.conf.d/docker-clean && \
 echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' \
	>> /etc/apt/apt.conf.d/docker-clean && \
 echo 'Acquire::Languages "none";' \
	> /etc/apt/apt.conf.d/docker-no-languages && \
 echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' \
	> /etc/apt/apt.conf.d/docker-gzip-indexes && \
 echo 'Apt::AutoRemove::SuggestsImportant "false";' \
	> /etc/apt/apt.conf.d/docker-autoremove-suggests && \
 mkdir -p /run/systemd && \
 echo 'docker' \
	> /run/systemd/container && \
 echo "**** install apt-utils and locales ****" && \
 apt-get update && \
 apt-get install -y \
	apt-utils \
	locales && \
 echo "**** install packages ****" && \
 apt-get install -y \
	curl \
        wget \
	patch \
	tzdata && \
 echo "**** generate locale ****" && \
 locale-gen en_US.UTF-8 && \
 /tmp/install_s6.sh && \
 echo "**** create ubuntu user and make our folders ****" && \
 useradd -u 1000 -U -d /config -s /bin/false ubuntu && \
 usermod -G users ubuntu && \
 mkdir -p \
	/app \
	/config \
	/defaults && \
 mv /usr/bin/with-contenv /usr/bin/with-contenvb && \
 patch -u /etc/s6/init/init-stage2 -i /tmp/patch/etc/s6/init/init-stage2.patch && \
 echo "**** cleanup ****" && \
 apt-get remove -y patch && \
 apt-get autoremove && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*



# add local files
COPY root/ /

ENTRYPOINT ["/init"]
