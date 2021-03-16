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
    git checkout canal-1.1.4

WORKDIR /opt/canal

COPY pom.xml .

RUN \
    mvn clean install -Denv=release -Dmaven.test.skip=true

FROM slpcat/openjdk:11-buster

RUN apt-get install -y file

COPY --from=build /opt/canal/target/canal.adapter-1.1.4.tar.gz  /tmp/

RUN \
    mkdir -p /opt/canal-adapter && \
    tar -zxf /tmp/canal.adapter-1.1.4.tar.gz -C /opt/canal-adapter && \
    rm -r /tmp/canal.adapter-1.1.4.tar.gz

COPY startup.sh /opt/canal-adapter/bin/startup.sh

WORKDIR /opt/canal-adapter

CMD ["sh", "-c", "./bin/startup.sh"]
