FROM centos
MAINTAINER Victor root@linuxidc.com
WORKDIR /root
RUN rm -f /etc/yum.repos.d/*
RUN  echo '[BASE]' > /etc/yum.repos.d/base.repo
RUN  echo 'name=base' >> /etc/yum.repos.d/base.repo
RUN  echo 'baseurl=http://192.168.244.132/yum/mnt' >> /etc/yum.repos.d/base.repo
RUN  echo 'enabled=1' >> /etc/yum.repos.d/base.repo
RUN  echo 'gpgcheck=0' >> /etc/yum.repos.d/base.repo
ADD /mysql /mysql
RUN yum  -y install java-1.8.0-openjdk wget httpd php php-mysqlnd /mysql/*
RUN mysql_install_db --user=mysql
ENV MYSQL_ROOT_PASSWORD=123456
ENV MYCAT_USER mycat
ENV MYCAT_PASS mycat
RUN wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-7/v7.0.64/bin/apache-tomcat-7.0.64.tar.gz
RUN tar xvf apache-tomcat-7.0.64.tar.gz -C /usr/local/ && mv /usr/local/apache-tomcat-7.0.64/ /usr/local/tomcat
RUN wget http://code.taobao.org/svn/openclouddb/downloads/old/MyCat-Sever-1.2/Mycat-server-1.2-GA-linux.tar.gz
RUN mkdir /usr/local/mycat && tar xvf Mycat-server-1.2-GA-linux.tar.gz -C /usr/local/mycat && useradd mycat && \
    chown -R mycat.mycat /usr/local/mycat && chmod a+x /usr/local/mycat/bin/*
EXPOSE 8080 8066 9066
COPY startup.sh /root/startup.sh
RUN chmod a+x /root/startup.sh
ENTRYPOINT /root/startup.sh

