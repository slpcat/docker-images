FROM slpcat/baseimage-rdesktop:focal

MAINTAINER 若虚 <slpcat@qq.com>

COPY .xsession /config/.xsession
COPY default-display-manager /etc/X11/default-display-manager
COPY sudoers /etc/sudoers

RUN \
    chown root:root /etc/sudoers && chmod 0440 /etc/sudoers

RUN \
    apt-get update -y && apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y lightdm lxde chromium-browser
