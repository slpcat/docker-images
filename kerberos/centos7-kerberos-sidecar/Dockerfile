#upstream https://github.com/edseymour/kinit-sidecar
FROM centos:centos7

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

COPY epel.repo /etc/yum.repos.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

RUN  \
    yum update -y && \
    yum clean all

#install the kerberos client tools
RUN yum install -y krb5-workstation && \
mkdir /krb5 && chmod 755 /krb5

# add resources, the kinit script and the default krb5 configuration
ADD rekinit.sh /
ADD krb5.conf /etc/krb5.conf

# configure the exported volumes
# /krb5 - default keytab location
# /dev/shm - shared memory location used to write token cache
# /etc/krb5.conf.d - directory for additional kerberos configuration
VOLUME ["/krb5","/dev/shm","/etc/krb5.conf.d"]
USER 1001
ENTRYPOINT ["/rekinit.sh"]
