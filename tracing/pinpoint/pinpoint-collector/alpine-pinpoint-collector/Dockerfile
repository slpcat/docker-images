FROM  slpcat/maven:centos7-all AS builder
MAINTAINER 若虚 <slpcat@qq.com>

ARG PINPOINT_VERSION=${PINPOINT_VERSION:-2.2.1}

RUN yum update -y && yum install -y  git libstdc++ nodejs npm nodejs-devel 

# install from source
RUN \
    git clone https://github.com/pinpoint-apm/pinpoint.git

WORKDIR /pinpoint
RUN \
    git checkout v$PINPOINT_VERSION \
    #patch APPLICATION_NAME_MAX_LEN=128 AGENT_NAME_MAX_LEN=128
    && sed -i s/24/128/ commons/src/main/java/com/navercorp/pinpoint/common/PinpointConstants.java \
    #change Hbase version
    #&& ./mvnw package install -Prelease -DskipTests=true
    && mvn clean install -Dhbase.shaded.client.version=2.1.1 -DskipTests=true

#FROM slpcat/tomcat8:alpine-8.5
FROM openjdk:8-jdk-alpine

MAINTAINER 若虚 <slpcat@qq.com>

ARG PINPOINT_VERSION=${PINPOINT_VERSION:-2.2.1}
#ARG INSTALL_URL=https://github.com/naver/pinpoint/releases/download/v${PINPOINT_VERSION}/pinpoint-collector-boot-${PINPOINT_VERSION}.jar

RUN mkdir -p /pinpoint/config \
    && mkdir -p /pinpoint/scripts

COPY --from=builder /pinpoint/collector/target/deploy/pinpoint-collector-boot-${PINPOINT_VERSION}.jar /pinpoint/pinpoint-collector-boot.jar

COPY pinpoint-collector.properties /pinpoint/config/
COPY start-collector.sh /pinpoint/scripts/

RUN \
    chmod a+x /pinpoint/scripts/start-collector.sh \
    && chmod a+x /pinpoint/config/pinpoint-collector.properties

ENTRYPOINT ["sh", "/pinpoint/scripts/start-collector.sh"]
