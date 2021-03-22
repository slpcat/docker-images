# upstream https://gitlab.com/gitlab-org/omnibus-gitlab/tree/master/docker
FROM debian:buster
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables and Gitlab version
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai" \
    RELEASE_PACKAGE="gitlab-ce" \
    RELEASE_VERSION="latest"

RUN \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils locales dialog tzdata \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      ca-certificates \
      openssh-server \
      wget \
      less \
      lsb-release \
      nano \
      curl \
      gnupg \
      apt-transport-https \
      vim

SHELL ["/bin/sh", "-c"],

# Remove MOTD
RUN rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic
RUN ln -fs /dev/null /run/motd.dynamic

# Copy assets
COPY RELEASE /
COPY assets/ /assets/
# as gitlab-ci checks out with mode 666 we need to set permissions of the files we copied into the
# container to a secure value. Issue #5956
RUN chmod -R og-w /assets RELEASE ; \
  /assets/setup

# Allow to access embedded tools
ENV PATH /opt/gitlab/embedded/bin:/opt/gitlab/bin:/assets:$PATH

# Resolve error: TERM environment variable not set.
ENV TERM xterm

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/assets/wrapper"]

HEALTHCHECK --interval=60s --timeout=30s --retries=5 \
CMD /opt/gitlab/bin/gitlab-healthcheck --fail --max-time 10
