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

# install kdc and kadmin
RUN yum install -y krb5-server krb5-workstation && yum clean all
RUN mkdir -p /var/kerberos/krb5kdc.d && \
    mkdir -p /etc/krb5.conf.d 

ADD init.sh /
ADD kdc.conf /var/kerberos/krb5kdc/
ADD krb5.conf /etc/

RUN chmod g+X,o+X,g+w,a+r -R /var/kerberos && \
    chmod g+X,o+X,g+w,a+r -R /etc/krb5.conf.d && \
    chmod 664 /etc/krb5.conf

RUN sed -i 's|kerberos-adm\ *749/tcp|kerberos-adm\ \ \ \ 8749/tcp|g' /etc/services && \
    sed -i 's|kpasswd\ *464/|kpasswd\ \ \ \ 8464/|g' /etc/services

VOLUME ["/var/kerberos/krb5kdc","/var/kerberos/krb5kdc.d", "/etc/krb5.conf.d" , "/dev/shm" ]
EXPOSE 8888 8464 8749

ENTRYPOINT ["/init.sh"]
