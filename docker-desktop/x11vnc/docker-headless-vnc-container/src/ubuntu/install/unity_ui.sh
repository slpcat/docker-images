#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Unity UI components"
apt-get update 
apt-get install -y supervisor ubuntu-desktop ubuntu-standard \
flashplugin-installer unity-tweak-tool gnome-tweak-tool \
ubuntu-kylin-software-center language-pack-zh-hans \
ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4 ibus-pinyin ibus-libpinyin ibus-sunpinyin
apt-get purge -y pm-utils xscreensaver*
apt-get clean -y
