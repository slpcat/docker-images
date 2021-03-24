FROM centos:7
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    container="docker" \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

COPY epel.repo /etc/yum.repos.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

RUN yum update -y && yum install -y cronie crontabs rsyslog net-tools

# set random root password
RUN P="$(dd if=/dev/random bs=1 count=8 2>/dev/null | base64)" ; echo $P && echo "root:$P" | chpasswd

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

# run stuff
ADD configurator.sh configurator_dumpenv.sh /root/
ADD configurator.service configurator_dumpenv.service /etc/systemd/system/
RUN chmod 700 /root/configurator.sh /root/configurator_dumpenv.sh && \
		systemctl enable configurator.service configurator_dumpenv.service

VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]
CMD ["/lib/systemd/systemd"]
