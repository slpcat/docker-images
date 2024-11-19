#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/kube-jenkins-dind-agent:openjdk21-ubuntu2404
LABEL org.opencontainers.image.authors="slpcat@qq.com"

USER root

#Apache Ant is a Java library and command-line tool that help building software.

RUN \
    wget https://dlcdn.apache.org/ant/binaries/apache-ant-1.10.14-bin.tar.gz \
    && tar zxf apache-ant-1.10.14-bin.tar.gz -C /usr/local \
    && ln -s /usr/local/apache-ant-1.10.14/bin/ant /usr/local/bin/ant \
    && rm apache-ant-1.10.14-bin.tar.gz

#jmeter
RUN \
    wget https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-5.6.2.tgz \
    && tar zxf apache-jmeter-5.6.2.tgz -C /usr/local \
    && ln -sf /usr/local/apache-jmeter-5.6.2/bin/jmeter /usr/local/bin/jmeter \
    && rm apache-jmeter-5.6.2.tgz

#gradle
RUN \
    wget https://services.gradle.org/distributions/gradle-7.3.3-bin.zip \
    && unzip -d /usr/local gradle-7.3.3-bin.zip \
    && ln -s /usr/local/gradle-7.3.3/bin/gradle /usr/local/bin/gradle \
    && rm gradle-7.3.3-bin.zip

ARG MAVEN_VERSION=3.9.5
ARG USER_HOME_DIR="/home/jenkins"
ARG SHA512=4810523ba025104106567d8a15a8aa19db35068c8c8be19e30b219a1d7e83bcab96124bf86dc424b1cd3c5edba25d69ec0b31751c136f88975d15406cab3842b
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
