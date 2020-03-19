#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Xfce4 UI components"
apt-get update 
apt-get install -y supervisor xfce4 xfce4-terminal ubuntu-standard xubuntu-desktop \
flashplugin-installer gnome-tweak-tool \
xfonts-wqy ttf-wqy-microhei ttf-wqy-zenhei language-pack-zh-hans \
ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4 ibus-pinyin ibus-libpinyin ibus-sunpinyin
apt-get purge -y pm-utils xscreensaver*
apt-get clean -y
