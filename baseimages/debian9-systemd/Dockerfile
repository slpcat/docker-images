FROM debian:stretch
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai" \
    DEBIAN_FRONTEND="noninteractive" \ 
    container="docker"

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny curl locales \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# add contrib, non-free and backports repositories
ADD sources.list /etc/apt/sources.list
# pin stable repositories
ADD preferences /etc/apt/preferences

# clean out, update and install some base utilities
RUN apt-get -y update && apt-get -y upgrade && apt-get clean && \
	apt-get -y install apt-utils lsb-release curl git cron at logrotate rsyslog \
		unattended-upgrades ssmtp lsof procps \
		initscripts libsystemd0 libudev1 systemd sysvinit-utils udev util-linux && \
	apt-get clean && \
	sed -i '/imklog/{s/^/#/}' /etc/rsyslog.conf

# set random root password
RUN P="$(dd if=/dev/random bs=1 count=8 2>/dev/null | base64)" ; echo $P && echo "root:$P" | chpasswd
# set to foobar
#RUN P="foobar" ; echo $P && echo "root:$P" | chpasswd

# unattended upgrades & co
ADD apt_unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
ADD apt_periodic /etc/apt/apt.conf.d/02periodic


RUN cd /lib/systemd/system/sysinit.target.wants/ && \
		ls | grep -v systemd-tmpfiles-setup.service | xargs rm -f && \
		rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
		systemctl mask -- \
			tmp.mount \
			etc-hostname.mount \
			etc-hosts.mount \
			etc-resolv.conf.mount \
			swap.target \
			getty.target \
			getty-static.service \
			dev-mqueue.mount \
			cgproxy.service \
			systemd-tmpfiles-setup-dev.service \
			systemd-remount-fs.service \
                        systemd-timedated \
			systemd-ask-password-wall.path \
			systemd-logind.service && \
		systemctl set-default multi-user.target || true

RUN sed -ri /etc/systemd/journald.conf \
			-e 's!^#?Storage=.*!Storage=volatile!'
ADD container-boot.service /etc/systemd/system/container-boot.service
RUN mkdir -p /etc/container-boot.d && \
		systemctl enable container-boot.service

# run stuff
ADD configurator.sh configurator_dumpenv.sh /root/
ADD configurator.service configurator_dumpenv.service /etc/systemd/system/
RUN chmod 700 /root/configurator.sh /root/configurator_dumpenv.sh && \
		systemctl enable configurator.service configurator_dumpenv.service

VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]
CMD ["/lib/systemd/systemd"]
