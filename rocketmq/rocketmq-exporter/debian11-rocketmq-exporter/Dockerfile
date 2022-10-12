FROM slpcat/maven:3.6-oraclejdk-8 AS build
MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    apt-get update && apt-get upgrade -y && apt-get install -y git

# install from source
RUN \
    cd /opt && \
    git clone https://github.com/apache/rocketmq-exporter.git && \
    cd rocketmq-exporter

WORKDIR /opt/rocketmq-exporter

RUN \
    mvn clean install -Dmaven.test.skip=true

FROM slpcat/oraclejdk:8-bullseye

RUN \
    mkdir -p /opt/rocketmq-exporter

COPY --from=build /opt/rocketmq-exporter/target/rocketmq-exporter-1.0.1-SNAPSHOT.jar  /opt/rocketmq-exporter

WORKDIR /opt/rocketmq-exporter

CMD ["sh", "-c", "java $JAVA_OPTS -jar rocketmq-exporter-0.0.2-SNAPSHOT.jar"]
