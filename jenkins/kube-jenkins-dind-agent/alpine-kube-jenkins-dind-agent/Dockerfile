#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/jdk:v1.8-alpine
MAINTAINER 若虚 <slpcat@qq.com>

RUN apk update              \
    && apk upgrade          \
    && apk add              \
       bzip2                \
       docker               \
       sudo                 \
       git                  \
       iptables             \
       jq                   \
       openrc               \
       openssh-client       \
       shadow               \
       unzip                \
       zip                  \
       libffi               \
       groff                \
       python3

#packer
RUN \
    wget https://releases.hashicorp.com/packer/1.7.0/packer_1.7.0_linux_amd64.zip \
    && unzip packer_1.7.0_linux_amd64.zip \
    && mv packer /usr/local/bin/ \
    && rm packer_1.7.0_linux_amd64.zip

#aliyun-cli
RUN \
    wget https://aliyuncli.alicdn.com/aliyun-cli-linux-3.0.60-amd64.tgz \
    && tar -zxvf aliyun-cli-linux-3.0.60-amd64.tgz \
    && mv aliyun /usr/local/bin \
    && rm aliyun-cli-linux-3.0.60-amd64.tgz

#terraform
RUN \
   wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip \
   && unzip terraform_0.14.7_linux_amd64.zip \
   && mv terraform /usr/local/bin/ \
   && rm terraform_0.14.7_linux_amd64.zip

#awscli
RUN \
    wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip awscli-exe-linux-x86_64.zip \
    && ./aws/install \
    && rm -rf aws*

#tccli 
RUN pip3 install tccli

COPY daemon.json /etc/docker/daemon.json

# jenkins slave
ENV HOME /home/jenkins

RUN groupadd -g 10000 jenkins \
    && useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins -s /bin/bash \
    && usermod -a -G docker jenkins \
    && sed -i '/^root/a\jenkins    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="3.20"

ARG VERSION=4.7
ARG AGENT_WORKDIR=/home/jenkins/agent

RUN curl --create-dirs -sSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar

ARG user=jenkins

USER root

COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

USER ${user}

ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}

ENTRYPOINT ["jenkins-agent"]
