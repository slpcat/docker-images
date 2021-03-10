FROM slpcat/maven:3.6-openjdk-11 AS build
MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    apt-get upgrade -y

# install from source
RUN \
    cd /opt && \
    git clone https://github.com/alibaba/canal/ && \
    cd canal && \
    git checkout canal-1.1.5-alpha-2

WORKDIR /opt/canal

COPY pom.xml .

RUN \
    mvn clean install -Denv=release -Dmaven.test.skip=true

FROM slpcat/openjdk:11-buster

RUN apt-get install -y file

COPY --from=build /opt/canal/target/canal.admin-1.1.5-SNAPSHOT.tar.gz  /tmp/

RUN \
    mkdir -p /opt/canal-admin && \
    tar -zxf /tmp/canal.admin-1.1.5-SNAPSHOT.tar.gz -C /opt/canal-admin && \
    rm -r /tmp/canal.admin-1.1.5-SNAPSHOT.tar.gz

COPY startup.sh /opt/canal-admin/bin/startup.sh

WORKDIR /opt/canal-admin

CMD ["sh", "-c", "./bin/startup.sh"]
