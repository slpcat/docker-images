FROM  slpcat/maven:centos7-all AS builder
MAINTAINER 若虚 <slpcat@qq.com>

ARG PINPOINT_VERSION=${PINPOINT_VERSION:-1.8.0}

RUN yum update -y && yum install -y  git libstdc++ nodejs npm nodejs-devel 

# install from source
RUN \
    git clone https://github.com/naver/pinpoint.git

WORKDIR /pinpoint
RUN \
    git checkout $PINPOINT_VERSION \
    #patch APPLICATION_NAME_MAX_LEN=128 AGENT_NAME_MAX_LEN=128
    && sed -i s/24/128/ commons/src/main/java/com/navercorp/pinpoint/common/PinpointConstants.java \
    #&& ./mvnw package install -Prelease -DskipTests=true
    && mvn package install -Dmaven.test.skip=true -Prelease

FROM slpcat/tomcat8:alpine-8.5
MAINTAINER 若虚 <slpcat@qq.com>

ARG PINPOINT_VERSION=${PINPOINT_VERSION:-1.8.0}
COPY --from=builder /pinpoint/collector/target/pinpoint-collector-${PINPOINT_VERSION}.war /pinpoint-collector-${PINPOINT_VERSION}.war
RUN \
    rm -rf /usr/local/tomcat/webapps \
    && mkdir -p /usr/local/tomcat/webapps/ROOT \
    && unzip /pinpoint-collector-${PINPOINT_VERSION}.war -d /usr/local/tomcat/webapps/ROOT \
    && rm /pinpoint-collector-${PINPOINT_VERSION}.war

COPY start-collector.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/start-collector.sh"]
