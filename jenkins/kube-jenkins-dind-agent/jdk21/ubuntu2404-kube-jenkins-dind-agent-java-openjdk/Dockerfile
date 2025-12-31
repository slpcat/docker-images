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
    wget https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-5.6.3.tgz \
    && tar zxf apache-jmeter-5.6.3.tgz -C /usr/local \
    && ln -sf /usr/local/apache-jmeter-5.6.3/bin/jmeter /usr/local/bin/jmeter \
    && rm apache-jmeter-5.6.3.tgz

#gradle
RUN \
    wget https://services.gradle.org/distributions/gradle-7.3.3-bin.zip \
    && unzip -d /usr/local gradle-7.3.3-bin.zip \
    && ln -s /usr/local/gradle-7.3.3/bin/gradle /usr/local/bin/gradle \
    && rm gradle-7.3.3-bin.zip

ARG MAVEN_VERSION=3.9.12
ARG USER_HOME_DIR="/home/jenkins"
ARG SHA512=0a1be79f02466533fc1a80abbef8796e4f737c46c6574ede5658b110899942a94db634477dfd3745501c80aef9aac0d4f841d38574373f7e2d24cce89d694f70
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
