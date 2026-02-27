FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
LABEL maintainer="thelamer"

# title
ENV TITLE="Ubuntu XFCE"

# Deploy ubuntu container without minimized packages
RUN yes | unminimize

ENV \
    TERM="xterm-256color" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

RUN \
    apt-get update && apt-get dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && echo "LANG=$LANG" > /etc/locale.conf \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && localedef -i en_US -c -f UTF-8 en_US.UTF-8 \

# Set timezone and locales
#RUN \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
      apt-utils \
      dialog \
      tzdata \
      language-pack-zh-hans \
      language-pack-zh-hans-base \
    && update-locale LANG=$LANG \
    && locale-gen $LANG zh_CN.UTF-8

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webtop-logo.png && \
  echo "**** install packages ****" && \
  add-apt-repository ppa:xtradeb/apps && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
    vim-tiny \
    wget     \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    fonts-symbola \
    ttf-ancient-fonts \
    im-config \
    fcitx5 \
    fcitx5-configtool \
    fcitx5-rime \
    fcitx5-table-emoji \
    fcitx5-chinese-addons \
    fcitx5-material-color \
    fcitx5-frontend-gtk4 \
    fcitx5-frontend-gtk3 \
    fcitx5-frontend-gtk2 \
    #language-selector-gnome \
    chromium \
    mousepad \
    xfce4-terminal \
    xfce4 \
    xubuntu-default-settings \
    xubuntu-icon-theme && \
    sed -i 's/^worker_processes.*$/worker_processes\ 2\;/' /etc/nginx/nginx.conf && \
  echo "**** xfce tweaks ****" && \
  sed -i \
    's#^Exec=.*#Exec=/usr/local/bin/wrapped-chromium#g' \
    /usr/share/applications/chromium.desktop && \
  mv \
    /usr/bin/exo-open \
    /usr/bin/exo-open-real && \
  mv \
    /usr/bin/thunar \
    /usr/bin/thunar-real && \
  mv \
    /usr/bin/chromium \
    /usr/bin/chromium-browser && \
  rm -f \
    /etc/xdg/autostart/xscreensaver.desktop && \
  echo "**** cleanup ****" && \
  apt-get remove --purge -y xscreensaver* network-manager && \
  apt-get autoremove --purge -y && \
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
