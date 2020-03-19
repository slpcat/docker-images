# x11docker/deepin
# 
# Run deepin desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Run desktop with:
#   x11docker --desktop --systemd x11docker/deepin
# (Alternativly start with:)
#   x11docker --desktop --dbus-system --pulseaudio x11docker/deepin
#
# Run single application:
#   x11docker x11docker/deepin deepin-terminal
#
# Options:

# Persistent home folder stored on host with   --home
# Shared host folder with                      --sharedir DIR
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# Change desired language locale setting with  --lang $LANG
# Sound support with option                    --pulseaudio
#
# See x11docker --help for further options.

FROM x11docker/deepin
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="zh_CN.UTF-8" \
    LANGUAGE="zh_CN.UTF-8" \
    LC_ALL="zh_CN.UTF-8" \
    TIMEZONE="Asia/Shanghai" \
    DEBIAN_FRONTEND="noninteractive"

#RUN echo "deb http://packages.deepin.com/deepin/ panda main non-free contrib" > /etc/apt/sources.list
RUN echo "deb [by-hash=force] http://mirrors.aliyun.com/deepin panda main contrib non-free" > /etc/apt/sources.list
#RUN echo "deb http://mirrors.kernel.org/deepin/  panda main non-free contrib" > /etc/apt/sources.list
#RUN echo "deb http://ftp.fau.de/deepin/          panda main non-free contrib" > /etc/apt/sources.list

RUN apt-get clean && apt-get -y update && \
    apt-get dist-upgrade -y && apt-get -y autoremove 

RUN apt-get install -y \
    lspci synaptic oneko google-chrome-stable firefox-zh \
    deepin-fpapp-com.deepin.imageviewer deepin-fpapp-com.deepin.music \
    deepin-fpapp-com.deepin.screenshot deepin-movie wps-office \
    foxitreader netease-cloud-music sogoupinyin fonts-adobe-source-han-serif-cn \
    fonts-droid fonts-hanazono fonts-lohit-deva fonts-nanum
