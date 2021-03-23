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

#kubectl
RUN \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

#helm
ARG VERIFY_CHECKSUM=false
RUN \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && bash get_helm.sh \
    && rm get_helm.sh

#istioctl
ARG ISTIO_VERSION=1.9.0
RUN \
    curl -L https://istio.io/downloadIstio | sh - \
    && mv istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin \
    && rm -rf  istio-${ISTIO_VERSION}

#packer
ARG PACKER_VERSION=1.7.0
RUN \
    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip packer_${PACKER_VERSION}_linux_amd64.zip \
    && mv packer /usr/local/bin/ \
    && rm packer_${PACKER_VERSION}_linux_amd64.zip

#aliyun-cli
ARG ALIYUN_CLI_VERSION=3.0.60
RUN \
    wget https://aliyuncli.alicdn.com/aliyun-cli-linux-${ALIYUN_CLI_VERSION}-amd64.tgz \
    && tar -zxvf aliyun-cli-linux-${ALIYUN_CLI_VERSION}-amd64.tgz \
    && mv aliyun /usr/local/bin \
    && rm aliyun-cli-linux-${ALIYUN_CLI_VERSION}-amd64.tgz

#terraform
ARG TERRAFORM_VERSION=0.14.7
RUN \
   wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
   && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
   && mv terraform /usr/local/bin/ \
   && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

#awscli
RUN \
    wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip awscli-exe-linux-x86_64.zip \
    && ./aws/install \
    && rm -rf aws*

#tccli 
RUN pip3 install tccli

COPY daemon.json /etc/docker/daemon.json

#tencent cloud COSCMD
RUN \
    pip3 install coscmd -U

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
