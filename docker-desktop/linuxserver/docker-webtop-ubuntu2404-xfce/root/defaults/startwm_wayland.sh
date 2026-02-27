#!/bin/bash
export INPUT_METHOD=fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
export SDL_IM_MODULE=fcitx5
export GLFW_IM_MODULE=ibus

#export https_proxy=http://127.0.0.1:7897
#export http_proxy=http://127.0.0.1:7897
#export all_proxy=socks5://127.0.0.1:7897

# 禁止OpenGL硬件加速
#export LIBGL_ALWAYS_SOFTWARE=1
#export GALLIUM_DRIVER=llvmpipe

# OpenGL强制使用 NVIDIA
#export __GLX_VENDOR_LIBRARY_NAME=nvidia
#export __NV_PRIME_RENDER_OFFLOAD=1
#export __VK_LAYER_NV_optimus=NVIDIA_only

# Default settings
if [ ! -d "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml ]; then
  mkdir -p "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml
  cp /defaults/xfce/* "${HOME}"/.config/xfce4/xfconf/xfce-perchannel-xml/
fi

# Start DE
WAYLAND_DISPLAY=wayland-1 Xwayland :1 &
sleep 2
exec dbus-launch --exit-with-session /usr/bin/xfce4-session > /dev/null 2>&1
