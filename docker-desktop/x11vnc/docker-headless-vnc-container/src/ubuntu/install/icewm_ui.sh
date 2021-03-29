#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install IceWM UI components"
apt-get update 
apt-get install -y supervisor icewm xterm xfonts-base xauth xinit \
flashplugin-installer \
xfonts-wqy ttf-wqy-microhei ttf-wqy-zenhei language-pack-zh-hans \
fcitx fcitx-googlepinyin fcitx-table-wbpy fcitx-pinyin fcitx-sunpinyin
apt-get purge -y pm-utils xscreensaver*
apt-get clean -y
