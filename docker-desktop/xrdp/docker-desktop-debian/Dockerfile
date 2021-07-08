# Copyright (c) 2019 FEROX YT EIRL, www.ferox.yt <devops@ferox.yt>
# Copyright (c) 2019 Jérémy WALTHER <jeremy.walther@golflima.net>
# See <https://github.com/frxyt/docker-xrdp> for details.

FROM debian:buster

LABEL maintainer="Jérémy WALTHER <jeremy@ferox.yt>"

# Install required packages to run
RUN     DEBIAN_FRONTEND=noninteractive apt-get update \
    &&  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --fix-missing --no-install-recommends \
            ca-certificates \
            curl \
            dbus-x11 \
            gnupg \
            openssh-server \
            sudo \
            supervisor \
            tigervnc-standalone-server \
            vim \
            xrdp \
    &&  apt-get clean -y && apt-get clean -y && apt-get autoclean -y && rm -r /var/lib/apt/lists/*

# Set default environment variables
ENV FRX_APTGET_DISTUPGRADE= \
    FRX_APTGET_INSTALL= \
    FRX_CMD_INIT= \
    FRX_CMD_START= \
    FRX_LOG_PREFIX_MAXLEN=6 \
    FRX_XRDP_CERT_SUBJ='/C=FX/ST=None/L=None/O=None/OU=None/CN=localhost' \
    FRX_XRDP_USER_NAME=debian \
    FRX_XRDP_USER_PASSWORD=ChangeMe \
    FRX_XRDP_USER_SUDO=1 \
    FRX_XRDP_USER_GID=1000 \
    FRX_XRDP_USER_UID=1000 \
    FRX_XRDP_USER_COPY_SA=0 \
    TZ=Etc/UTC

# Copy assets
COPY build/log                  /usr/local/bin/frx-log
COPY build/start                /usr/local/sbin/frx-start
COPY build/supervisord.conf     /etc/supervisor/supervisord.conf
COPY build/xrdp.ini             /etc/xrdp/xrdp.ini

# Configure installed packages
RUN     echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ALL \
    &&  sed -e 's/^#\?\(PermitRootLogin\)\s*.*$/\1 no/' \
            -e 's/^#\?\(PasswordAuthentication\)\s*.*$/\1 yes/' \
            -e 's/^#\?\(PermitEmptyPasswords\)\s*.*$/\1 no/' \
            -e 's/^#\?\(PubkeyAuthentication\)\s*.*$/\1 yes/' \
            -i /etc/ssh/sshd_config \
    &&  mkdir -p /run/sshd \
    &&  mkdir -p /var/run/dbus \
    &&  mkdir -p /frx/entrypoint.d \
    &&  rm -f /etc/xrdp/cert.pem /etc/xrdp/key.pem /etc/xrdp/rsakeys.ini \
    &&  rm -f /etc/ssh/ssh_host_*

# Prepare default desktop if needed & version information
ARG DOCKER_TAG
ARG SOURCE_BRANCH
ARG SOURCE_COMMIT
COPY build/desktop /usr/local/sbin/frx-desktop
RUN     echo "[frxyt/xrdp:${DOCKER_TAG}] <https://github.com/frxyt/docker-xrdp>" > /frx/version \
    &&  echo "[version: ${SOURCE_BRANCH}@${SOURCE_COMMIT}]" >> /frx/version \
    &&  /usr/local/sbin/frx-desktop ${DOCKER_TAG}

# Copy source files
COPY Dockerfile LICENSE README.md /frx/

EXPOSE 22
EXPOSE 3389

VOLUME [ "/home" ]
WORKDIR /home

CMD [ "/usr/local/sbin/frx-start" ]