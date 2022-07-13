FROM slpcat/debian:bullseye as builder-jdk8

MAINTAINER 若虚 <slpcat@qq.com>

#install JDK 8
ENV JAVA_VERSION=8 \
    JAVA_UPDATE=321 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

ARG TARGETARCH

COPY jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-*.tar.gz install_jdk8.sh /tmp/

RUN \
    /tmp/install_jdk8.sh /tmp/

FROM slpcat/debian:bullseye as builder-jdk17

MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    rm -rf /var/lib/apt/lists/

#install JDK 17
ENV JAVA_VERSION=17.0.2 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

ARG TARGETARCH

COPY jdk-${JAVA_VERSION}_linux-*_bin.tar.gz install_jdk17.sh /tmp/

RUN \
    /tmp/install_jdk17.sh /tmp/

#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/kube-jenkins-dind-agent:oraclejdk11-bullseye
MAINTAINER 若虚 <slpcat@qq.com>

USER root

COPY --from=builder-jdk8 /usr/lib/jvm /usr/lib/jvm
COPY --from=builder-jdk17 /usr/lib/jvm /usr/lib/jvm

#Apache Ant is a Java library and command-line tool that help building software.

RUN \
    wget https://dlcdn.apache.org/ant/binaries/apache-ant-1.10.12-bin.tar.gz \
    && tar zxf apache-ant-1.10.12-bin.tar.gz -C /usr/local \
    && ln -s /usr/local/apache-ant-1.10.12/bin/ant /usr/local/bin/ant \
    && rm apache-ant-1.10.12-bin.tar.gz

#jmeter
RUN \
    wget https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-5.4.3.tgz \
    && tar zxf apache-jmeter-5.4.3.tgz -C /usr/local \
    && ln -sf /usr/local/apache-jmeter-5.4.3/bin/jmeter /usr/local/bin/jmeter \
    && rm apache-jmeter-5.4.3.tgz


#gradle
RUN \
    wget https://services.gradle.org/distributions/gradle-7.3.3-bin.zip \
    && unzip -d /usr/local gradle-7.3.3-bin.zip \
    && ln -s /usr/local/gradle-7.3.3/bin/gradle /usr/local/bin/gradle \
    && rm gradle-7.3.3-bin.zip

ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/home/jenkins"
ARG SHA512=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
#ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ARG BASE_URL=http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA512}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/
COPY settings.xml $USER_HOME_DIR/.m2/

#RUN chown -R jenkins:jenkins $USER_HOME_DIR

#USER jenkins
