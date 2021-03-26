# upstream https://gitlab.com/gitlab-org/omnibus-gitlab/tree/master/docker
FROM debian:stretch
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

RUN echo 'deb http://mirrors.aliyun.com/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com\/debian-security/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils locales \ 
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
      curl \
      gnupg \
      apt-transport-https \
      vim

# Download & Install GitLab
# If you run GitLab Enterprise Edition point it to a location where you have downloaded it.
# repo from tsinghua university
#&& sed -i 's/https:\/\/packages.gitlab.com\/gitlab/http:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list.d/gitlab_gitlab-ce.list \
RUN \
    curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends gitlab-ce \
    && apt-get clean all

# Manage SSHD through runit
RUN \
    mkdir -p /opt/gitlab/sv/sshd/supervise \
    && mkfifo /opt/gitlab/sv/sshd/supervise/ok \
    && printf "#!/bin/sh\nexec 2>&1\numask 077\nexec /usr/sbin/sshd -D" > /opt/gitlab/sv/sshd/run \
    && chmod a+x /opt/gitlab/sv/sshd/run \
    && ln -s /opt/gitlab/sv/sshd /opt/gitlab/service \
    && mkdir -p /var/run/sshd

# SSH configuration
COPY assets/sshd_config /etc/ssh/sshd_config

# Prepare default configuration
COPY assets/gitlab.rb /etc/gitlab/gitlab.rb
COPY assets/update-permissions /usr/sbin/

# Patch omnibus package,Patch runsvdir-start,Patch cookbook
RUN \
    sed -i "s/external_url 'GENERATED_EXTERNAL_URL'/# external_url 'GENERATED_EXTERNAL_URL'/" /opt/gitlab/etc/gitlab.rb.template \
    && sed -i /file-max/d /opt/gitlab/embedded/bin/runsvdir-start \
    && sed -i s/^ulimit/#ulimit/ /opt/gitlab/embedded/bin/runsvdir-start \
    && sed -i /sysctl/,+2d /opt/gitlab/embedded/cookbooks/gitlab/recipes/unicorn.rb \
    && sed -i /sysctl/,+2d /opt/gitlab/embedded/cookbooks/postgresql/recipes/enable.rb \
    && rm -f /opt/gitlab/embedded/cookbooks/package/resources/sysctl.rb 

# Expose web & ssh
EXPOSE 80/tcp 443/tcp 22/tcp

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

# Copy assets
COPY assets/wrapper /usr/local/bin/

# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/usr/local/bin/wrapper"]

HEALTHCHECK --interval=60s --timeout=30s --retries=5 \
CMD /opt/gitlab/bin/gitlab-healthcheck --fail
