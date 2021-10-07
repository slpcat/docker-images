FROM slpcat/baseimage-rdesktop:focal

MAINTAINER 若虚 <slpcat@qq.com>

COPY .xsession /config/.xsession
COPY default-display-manager /etc/X11/default-display-manager
COPY sudoers /etc/sudoers
COPY services.d /etc/services.d/

RUN \
    chown root:root /etc/sudoers && chmod 0440 /etc/sudoers

RUN \
    apt-get update -y && apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y lightdm \
    lxde firefox docker-ce wget vim-tiny \
    pavumeter language-pack-zh-hans \
    ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-pinyin ibus-libpinyin ibus-sunpinyin \
    htop iotop iftop net-tools tmux

#install chrome browser
RUN \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    apt-get update -y && \
    apt-get install -y google-chrome-stable
#apt-get install snapcraft
#apt install chromium-browser
 
