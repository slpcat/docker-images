#!/bin/bash
set -x -e

#https://github.com/linuxserver/proot-apps
#PRoot Apps is a simple platform to install and use applications without any privileges in Linux userspace using PRoot
#Install or update
rm -f $HOME/.local/bin/{ncat,proot-apps,proot,jq}
mkdir -p $HOME/.local/bin
curl -L https://github.com/linuxserver/proot-apps/releases/download/$(curl -sX GET "https://api.github.com/repos/linuxserver/proot-apps/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')/proot-apps-$(uname -m).tar.gz | tar -xzf - -C $HOME/.local/bin/
export PATH="$HOME/.local/bin:$PATH"


# nvidia OpenGL for flatpak
#flatpak install -y flathub org.freedesktop.Platform.GL.nvidia-580-119-02
# OpenGL强制使用 NVIDIA
#flatpak override \
#    --env=__GLX_VENDOR_LIBRARY_NAME=nvidia \
#    --env=__NV_PRIME_RENDER_OFFLOAD=1 \
#    --env=__VK_LAYER_NV_optimus=NVIDIA_only

#PhotoGIMP
#https://github.com/Diolinux/PhotoGIMP/releases

#Kiwix is an offline reader - meaning that it allows you to check text or video that is normally only available on the internet.
#flatpak install flathub org.kiwix.desktop
#https://download.kiwix.org/release/kiwix-desktop/kiwix-desktop_x86_64.appimage
#https://download.kiwix.org/zim/wikipedia/

#XOWA is the free, open-source application that lets you download Wikipedia to your computer.
#http://xowa.org/

#davinciresolve
#http://www.blackmagicdesign.com/cn/products/davinciresolve

# topazlabs
# Topaz Video AI Linux Beta

# OpenShot Editor
# flatpak install -y flathub org.openshot.OpenShot
# Shotcut Editor
# flatpak install -y flathub org.shotcut.Shotcut
# Olive

# Flowblade is a multitrack non-linear video editor for Linux released under GPL 3 license.
# https://github.com/jliljebl/flowblade
# apt install flowblade

#Synfig Studio
#Open-source 2D Animation Software
# https://www.synfig.org/
# OpenToonz is a 2D animation software published by DWANGO.
# https://github.com/opentoonz/opentoonz

# PikoPixel is an easy-to-use application for drawing & editing pixel-art.

# Ardour is a Digital Audio Workstation (DAW), suitable for recording, mixing and mastering.
# apt install ardour

# Zrythm
# Mixxx
# Qtractor
# LMMS 
# Hydrogen
# Tenacity (Audacity 分支)
# Rosegarden
# MuseScore Studio 
# 


#DisplayCAL (formerly known as dispcalGUI) is a display calibration and profiling solution with a focus on accuracy and versatility.
# apt-get install displaycal

#Natron Visual Effects Without Limits.
#https://natrongithub.github.io/
#https://github.com/NatronGitHub/Natron
#flatpak install fr.natron.Natron

#Astrofox is a motion graphics program that lets turn audio into amazing videos.
#https://astrofox.io/
#https://github.com/astrofox-io/astrofox

# wav2bar The free, open source audio visualization creator.

#Gaffer is a free, open-source, node-based VFX application that enables look developers, lighters, and compositors to easily build, tweak, iterate, and render scenes.
#https://www.gafferhq.org/
#https://download.cinelerra-gg.org/
#https://github.com/GafferHQ/gaffer/releases/download/1.6.10.0/gaffer-1.6.10.0-linux-gcc11.tar.gz

#Cinelerra GG Infinity is a free and open source video editing software for Linux.
#https://cinelerra-gg.org/
# apt-add-repository https://cinelerra-gg.org/download/pkgs/ub24
# apt install cin

#Kitsu is a collaboration platform for animation and VFX productions..
#https://github.com/cgwire/kitsu

#AI视频画质提升/增强工具
#Video2X
#Real-ESRGAN
#Waifu2x Extension GUI
#Anime4K
#REAL Video Enhancer
#https://github.com/TNTwise/REAL-Video-Enhancer
#flatpak install -y flathub io.github.tntwise.REAL-Video-Enhancer

