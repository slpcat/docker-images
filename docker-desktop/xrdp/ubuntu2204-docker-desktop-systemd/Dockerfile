#FROM ghcr.io/linuxserver/baseimage-ubuntu:focal
FROM slpcat/baseimage-ubuntu:systemd-jammy

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN \
 echo "**** install deps ****" && \
 ldconfig && \
 apt-get update && \
 DEBIAN_FRONTEND=noninteractive \
 apt-get install -y --no-install-recommends \
	apt-transport-https \
	ca-certificates \
	curl \
 	dbus-x11 \
        dialog \
	gawk \
	gnupg2 \
	libfuse2 \
	libx11-dev \
	libxfixes3 \
	libxml2 \
	libxrandr2 \
	pulseaudio \
	software-properties-common \
	sudo \
	x11-apps \
	x11-xserver-utils \
	xfonts-base \
	xorgxrdp \
	xrdp \
	xserver-xorg-core \
	xutils \
	zlib1g && \
 apt-get autoclean && \
 rm -rf \
	/var/lib/apt/lists/* \
	/var/tmp/* \
	/tmp/*

# add local files

#COPY .xsession /config/.xsession
#COPY default-display-manager /etc/X11/default-display-manager

RUN \
    apt-get update -y && apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y lightdm \
    ubuntu-desktop firefox vim-tiny \
    pavumeter language-pack-zh-hans \
    ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-pinyin ibus-libpinyin ibus-sunpinyin

#install chrome browser
RUN \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    apt-get update -y && \
    apt-get install -y google-chrome-stable
#apt-get install snapcraft
#apt install chromium-browser

# ports and volumes
EXPOSE 3389
