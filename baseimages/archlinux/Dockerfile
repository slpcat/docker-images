FROM archlinux

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    #LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

COPY etc /etc/

RUN  \
    pacman -Syu --noconfirm \
    && pacman -S --noconfirm vim net-tools curl wget less

CMD ["/bin/bash"]
