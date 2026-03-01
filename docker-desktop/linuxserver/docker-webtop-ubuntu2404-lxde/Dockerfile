FROM slpcat/linuxserver-baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE="Ubuntu lxqt" \
    SELKIES_WAYLAND_SOCKET_INDEX=2

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webtop-logo.png && \
  echo "**** install packages ****" && \
  add-apt-repository ppa:xtradeb/apps && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends \
    #chromium \
    i3 \
    i3-wm \
    #stterm \
    lxqt-core \
    #lxpanel can not work
    icewm \
    gexec \
    lxterminal \
    xfe \
    sway \
    sway-backgrounds \
    swaybg && \
    apt-get remove --purge -y xscreensaver* network-manager && \
    apt-get autoremove --purge -y && \
  echo "**** application tweaks ****" && \
  #update-alternatives --set \
  #  x-terminal-emulator \
  #  /usr/bin/st && \
  #mv \
  #  /usr/bin/chromium \
  #  /usr/bin/chromium-browser && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
