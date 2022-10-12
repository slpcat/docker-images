FROM slpcat/maven:3.6-oraclejdk-8 AS build
MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    apt-get update && apt-get upgrade -y && apt-get install -y git 

# install from source
RUN \
    cd /opt && \
    git clone https://github.com/apache/rocketmq-dashboard.git && \
    cd rocketmq-dashboard

WORKDIR /opt/rocketmq-dashboard

RUN \
    mvn clean package -Dmaven.test.skip=true

FROM slpcat/oraclejdk:8-bullseye

RUN \
    mkdir -p /opt/rocketmq-dashboard

COPY --from=build /opt/rocketmq-dashboard/target/rocketmq-dashboard-1.0.1-SNAPSHOT.jar  /opt/rocketmq-dashboard

WORKDIR /opt/rocketmq-dashboard

CMD ["sh", "-c", "java $JAVA_OPTS -jar rocketmq-dashboard-1.0.1-SNAPSHOT.jar"]
