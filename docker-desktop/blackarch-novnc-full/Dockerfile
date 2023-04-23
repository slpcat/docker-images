FROM slpcat/blackarchlinux:novnc-base

COPY mirrorlist /etc/pacman.d/mirrorlist
COPY blackarch-mirrorlist /etc/pacman.d/blackarch-mirrorlist

COPY environment /etc/environment 

RUN \
    pacman -Syu --noconfirm yay && \
    yay --aururl "https://mirrors.aliyun.com/archlinuxcn" --save

RUN \
    pacman -Syu --noconfirm fcitx5-im fcitx5-gtk fcitx5-chinese-addons  \
    fcitx5-rime \
    pocl wqy-bitmapfont  wqy-microhei wqy-microhei-lite wqy-zenhei \
    adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts \
    ttf-dejavu noto-fonts noto-fonts-extra noto-fonts-emoji noto-fonts-cjk \
    firefox firefox-i18n-zh-cn chromium

RUN yay -S microsoft-edge
