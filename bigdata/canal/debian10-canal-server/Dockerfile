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

COPY --from=build /opt/canal/target/canal.deployer-1.1.5-SNAPSHOT.tar.gz  /tmp/

RUN \
    mkdir -p /opt/canal-server && \
    tar -zxf /tmp/canal.deployer-1.1.5-SNAPSHOT.tar.gz -C /opt/canal-server && \
    rm -r /tmp/canal.deployer-1.1.5-SNAPSHOT.tar.gz

COPY startup.sh /opt/canal-server/bin/startup.sh

WORKDIR /opt/canal-server

CMD ["sh", "-c", "./bin/startup.sh"]
