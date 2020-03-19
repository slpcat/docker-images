FROM clearlinux
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TIMEZONE="Asia/Shanghai"

# Set timezone and locales
RUN set -ex \
    && swupd bundle-add locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
