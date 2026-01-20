#upstream https://github.com/debuerreotype/docker-debian-artifacts/blob/de09dd55b6328b37b89a33e76b698f9dbe611fab/jessie/backports/Dockerfile
FROM debian:bookworm as build
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y curl make gcc

RUN curl -s -L https://github.com/ncopa/su-exec/archive/v0.2.tar.gz | tar zx -C /opt/ \
    && mv /opt/su-exec* /opt/su-exec \
    && cd /opt/su-exec \
    && make

####################################

FROM debian:bookworm
LABEL org.opencontainers.image.authors="slpcat@qq.com"

RUN rm -f /etc/apt/sources.list.d/debian.sources
COPY rootfs/ /

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y binutils ethtool vim-tiny net-tools iproute2 procps curl wget telnet less unzip && \
    rm -rf /var/lib/apt/lists/

# For slim:
#   --build-arg ADDITIONAL_APT_GET_OPTS=--no-install-recommends
ARG ADDITIONAL_APT_GET_OPTS=""

RUN \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y $ADDITIONAL_APT_GET_OPTS \
      vim-tiny \
      dbus-x11 \
      fonts-noto-cjk \
      #fcitx5 \
      #fcitx5-chinese-addons \
      #fcitx5-material-color \
      #im-switch \
      #language-pack-ja \
      #language-pack-ja-base \
      #lxde-core \
      #lxpanel can not work
      icewm \
      #gexec \
      #l3afpad \
      #qpdfview \
      #lxterminal \
      zzzfm \
      #audacious \
      #audacious-plugins \
      #gpicview \
      #vlc \
      #smplayer \
      sudo \
      tzdata \
      runit \
      #xorg \
      xorgxrdp \
      xrdp \
    && apt-get remove --purge -y at-spi2-core system-config-printer* cups* pm-utils xscreensaver* ibus* upower udisks2 network-manager && apt-get autoremove --purge -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build \
    /opt/su-exec/su-exec /usr/sbin/su-exec

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV \
    TERM="xterm-256color" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

# Set timezone and locales
RUN \
    echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog tzdata \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales


# Set default vars
ENV DEFAULT_USER=developer \
    DEFAULT_PASSWD=xrdppasswd

# Set sudoers for any user
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ALL

# Change permission so that non-root user can add users and groups
RUN chmod u+s /usr/sbin/useradd \
    && chmod u+s /usr/sbin/groupadd

# Expose RDP port
EXPOSE 3389

# Setup
RUN { \
        echo 'if [[ -d /run/user/$(id -u) ]]; then'; \
        echo '  export XDG_RUNTIME_DIR=/run/user/$(id -u)'; \
        echo 'fi'; \
        echo 'exec dbus-run-session -- icewm-session'; \
    } > /etc/skel/.xsession \
    && install -o root -g xrdp -m 2775 -d /var/run/xrdp \
    && install -o root -g xrdp -m 3777 -d /var/run/xrdp/sockdir \
    && install -o root -g root -m 0755 -d /var/run/dbus \
    && install -o root -g root -m 0644 /dev/null /etc/securetty \
    && usermod -aG ssl-cert xrdp \
    && sed -i 's|\[Session\]|&\npolkit/command=|' /etc/xdg/lxsession/LXDE/desktop.conf \
    && usermod -aG ssl-cert xrdp \
    && ln -s /usr/share/lxde/wallpapers/lxde_blue.jpg /etc/alternatives/desktop-background

COPY rootfs/ /
# Disable unavailable features
RUN sed -i 's|.*pam_systemd.so|#&|g' /etc/pam.d/common-session \
    && rm -f /etc/xdg/autostart/geoclue-demo-agent.desktop \
#    && rm -f /etc/xdg/autostart/at-spi-dbus-bus.desktop \
#    && rm -f /etc/xdg/autostart/parcellite-startup.desktop \
#    && rm -f /etc/xdg/autostart/nm-applet.desktop \
    && rm -f /etc/xdg/autostart/org.gnome.Evolution-alarm-notify.desktop \
    && rm -f /etc/xdg/autostart/org.gnome.SettingsDaemon.Power.desktop

# Copy entrypoint script
COPY runit-entrypoint.sh /usr/local/bin/
RUN \
    chmod +x /etc/sv/*/run \
    && chmod +x /usr/local/bin/runit-entrypoint.sh
ENTRYPOINT ["runit-entrypoint.sh"]
