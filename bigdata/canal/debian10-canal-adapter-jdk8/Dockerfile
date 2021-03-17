FROM slpcat/maven:alpine AS build
MAINTAINER 若虚 <slpcat@qq.com>

# install from source
RUN \
    mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/alibaba/canal/ && \
    cd canal && \
    git checkout canal-1.1.5-alpha-2

WORKDIR /opt/canal

COPY pom.xml .

RUN \
    mvn clean install -Denv=release -Dmaven.test.skip=true

FROM slpcat/openjdk:8

RUN apt-get install -y file

COPY --from=build /opt/canal/target/canal.adapter-1.1.5-SNAPSHOT.tar.gz  /tmp/

RUN \
    mkdir -p /opt/canal-adapter && \
    tar -zxf /tmp/canal.adapter-1.1.5-SNAPSHOT.tar.gz -C /opt/canal-adapter && \
    rm -r /tmp/canal.adapter-1.1.5-SNAPSHOT.tar.gz

COPY startup.sh /opt/canal-adapter/bin/startup.sh

WORKDIR /opt/canal-adapter

CMD ["sh", "-c", "./bin/startup.sh"]
