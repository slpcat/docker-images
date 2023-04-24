FROM slpcat/blackarchlinux:novnc-base

COPY etc /

RUN \
#    pacman-key --init && \
#    pacman-key --refresh-keys && \
    pacman -Syu --noconfirm yay archlinuxcn-keyring 
#    yay --aururl "https://aur.archlinux.org" --save

RUN \
    pacman -Syu --noconfirm fcitx5-im fcitx5-gtk fcitx5-chinese-addons  \
    fcitx5-rime \
    pocl wqy-bitmapfont  wqy-microhei wqy-microhei-lite wqy-zenhei \
    adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts \
    ttf-dejavu noto-fonts noto-fonts-extra noto-fonts-emoji noto-fonts-cjk \
    firefox firefox-i18n-zh-cn chromium

RUN yay -S microsoft-edge teamviewer todesk sunloginclient \
    wps-office-mui-zh-cn wps-office-mime-cn wps-office-cn wps-office-fonts ttf-ms-fonts  ttf-wps-fonts

