FROM slpcat/baseimage-rdesktop:focal

MAINTAINER 若虚 <slpcat@qq.com>

COPY .xsession /config/.xsession
COPY default-display-manager /etc/X11/default-display-manager
COPY sudoers /etc/sudoers

RUN \
    chown root:root /etc/sudoers && chmod 0440 /etc/sudoers

RUN \
    apt-get update -y && apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y lightdm lxde firefox docker-ce wget vim-tiny

#install chrome browser
#RUN \
#    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
#    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
#    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

 
