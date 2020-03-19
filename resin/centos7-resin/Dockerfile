FROM  slpcat/maven:centos7 AS builder
MAINTAINER 若虚 <slpcat@qq.com>

# install from source
ARG VERSION=v1.0
RUN \
    git clone https://git.com/user/code.git
    git checkout $VERSION \
    && mvn package install -Dmaven.test.skip=true -Prelease

FROM slpcat/jdk:centos7

MAINTAINER 若虚 <slpcat@qq.com>

#install resin
ENV RESIN_HOME=/opt/resin
ARG RESIN_VERSION=4.0.56

RUN \
    yum update -y && \
    yum install -y wget file which make gcc openssl-devel && \
    wget http://caucho.com/download/resin-${RESIN_VERSION}.tar.gz && \
    tar -xf resin-${RESIN_VERSION}.tar.gz -C /opt && \
    ln -sf /opt/resin-${RESIN_VERSION} /opt/resin && \
    cd /opt/resin && \
    ./configure --prefix=`pwd` && \
    make && \
    make install && \
    rm /resin-${RESIN_VERSION}.tar.gz && \
    yum remove -y gcc make  openssl-devel

#change config
#RUN sed -i ....

#COPY --from=builder /path/to/java.war /opt/resin/webapps/

EXPOSE 8080
CMD ["/opt/resin/bin/resin.sh","console"]
