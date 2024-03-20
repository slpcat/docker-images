FROM slpcat/archlinux
MAINTAINER 若虚 <slpcat@qq.com>

ENV PATH /usr/local/bin:$PATH

COPY pip.conf /etc/pip.conf
RUN chmod 644 /etc/pip.conf

RUN  \
    pacman -Syu --noconfirm \
    && pacman -S --noconfirm git python python-pip
