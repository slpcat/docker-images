#upstream https://github.com/debuerreotype/docker-debian-artifacts/blob/de09dd55b6328b37b89a33e76b698f9dbe611fab/jessie/backports/Dockerfile
FROM slpcat/antix:core-23.2 as build
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y curl make gcc libc6-dev sudo wget unzip

RUN curl -s -L https://github.com/ncopa/su-exec/archive/v0.2.tar.gz | tar zx -C /opt/ \
    && mv /opt/su-exec* /opt/su-exec \
    && cd /opt/su-exec \
    && make

#RUN \
#    echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ALL && \
#    apt-get update && apt-get install -y xorg xdg-user-dirs lsb-release xdg-utils
#
#USER antix
#WORKDIR /home/antix
#
#RUN \
#    wget https://www.c-nergy.be/downloads/xRDP/xrdp-installer-1.5.5.zip && \
#    unzip xrdp-installer-1.5.5.zip && \
#    bash ./xrdp-installer-1.5.5/xrdp-installer-1.5.5.sh -c -l -s -e

####################################

FROM slpcat/antix:core-23.2
LABEL org.opencontainers.image.authors="slpcat@qq.com"

# For slim:
#   --build-arg ADDITIONAL_APT_GET_OPTS=--no-install-recommends
ARG ADDITIONAL_APT_GET_OPTS=""

RUN \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y $ADDITIONAL_APT_GET_OPTS \
      vim-tiny \
      dbus-x11 \
      fonts-noto-cjk \
      fcitx5 \
      fcitx5-frontend-all \
      fcitx5-chinese-addons \
      fcitx5-material-color \
      im-config \
      #language-pack-ja \
      #language-pack-ja-base \
      #lxde-core \
      #lxpanel can not work
      desktop-defaults-base-antix \
      desktop-defaults-icewm-antix \
      desktop-menu-antix \
      gir1.2-gtk-3.0 \
      icewm \
      icewm-base-themes-antix \
      icewm-icons-papirus-antix \
      gexec \
      lxterminal \
      #roxterm \
      #zzzfm \
      xfe \
      sudo \
      tzdata \
      #xorg \
      xorgxrdp \
      xrdp \
    && apt-get remove --purge -y at-spi2-core system-config-printer* cups* pm-utils xscreensaver* ibus* upower udisks2 network-manager && apt-get autoremove --purge -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build \
    /opt/su-exec/su-exec /usr/sbin/su-exec

#COPY --from=build \
#    /home/debian/Downloads/xrdp/xrdp_0.10.4.1-1_amd64.deb /tmp/
#   xorg-xrdp pulse-audio

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
    #&& sed -i 's|\[Session\]|&\npolkit/command=|' /etc/xdg/lxsession/LXDE/desktop.conf \
    && usermod -aG ssl-cert xrdp
    #&& ln -s /usr/share/lxde/wallpapers/lxde_blue.jpg /etc/alternatives/desktop-background

COPY rootfs/ /
# Disable unavailable features
RUN sed -i 's|.*pam_systemd.so|#&|g' /etc/pam.d/common-session \
    && rm -f /etc/xdg/autostart/geoclue-demo-agent.desktop \
#    && rm -f /etc/xdg/autostart/at-spi-dbus-bus.desktop \
#    && rm -f /etc/xdg/autostart/parcellite-startup.desktop \
#    && rm -f /etc/xdg/autostart/nm-applet.desktop \
    && rm -f /etc/xdg/autostart/org.gnome.Evolution-alarm-notify.desktop \
    && rm -f /etc/xdg/autostart/org.gnome.SettingsDaemon.Power.desktop

RUN \
    # update desktop menus
    /usr/local/lib/desktop-menu/desktop-menu-apt-update check && \
    unlink /etc/service/slimski && \
    unlink /etc/service/slim && \
    unlink /etc/service/avahi-daemon && \
    #unlink /etc/service/lightdm && \
    #unlink /etc/service/elogind && \
    ln -s /etc/sv/xrdp /etc/service/xrdp && \
    ln -s /etc/sv/xrdp-sesman /etc/service/xrdp-sesman && \
    rm -f rm /var/run/xrdp/xrdp-sesman.pid /var/run/xrdp/xrdp.pid

# Copy entrypoint script
COPY runit-entrypoint.sh /usr/local/bin/
RUN \
    chmod +x /etc/sv/*/run \
    && chmod +x /usr/local/bin/runit-entrypoint.sh
ENTRYPOINT ["runit-entrypoint.sh"]
