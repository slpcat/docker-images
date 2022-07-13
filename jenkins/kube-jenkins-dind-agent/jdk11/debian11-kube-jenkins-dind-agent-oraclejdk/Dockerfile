#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/oraclejdk:11-bullseye
MAINTAINER 若虚 <slpcat@qq.com>

RUN apt-get update -y             \
    && apt-get upgrade -y         \
    && apt-get install -y         \
       apt-transport-https        \
       bison                      \
       ca-certificates            \
       net-tools                  \
       procps                     \
       curl                       \
       rsync                      \
       gnupg-agent                \
       software-properties-common \
       bzip2                \
       sudo                 \
       git                  \
       iptables             \
       jq                   \
       openrc               \
       openssh-client       \
       unzip                \
       zip                  \
       groff                \
       python3              \
       python3-pip

COPY pip.conf /etc/pip.conf

#install docker-ce
RUN \    
    curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/debian/gpg | apt-key add - && \
    echo 'deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/debian bullseye stable' > /etc/apt/sources.list.d/docker-ce.list && \
    apt-get update -y &&\
    apt-get install -y docker-ce 

#install ansible
RUN \
    pip3 install netaddr pbr hvac jmespath ruamel.yaml ansible

#Robot Framework is a generic open source automation framework.
RUN \
    pip3 install robotframework

#kubectl
RUN \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

#helm
ARG VERIFY_CHECKSUM=false
#RUN \
#    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
#    && bash get_helm.sh \
#    && rm get_helm.sh
RUN \
    curl https://baltocdn.com/helm/signing.asc | apt-key add - \
    && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update \
    && apt-get install -y helm

#istioctl
ARG ISTIO_VERSION=1.12.2
RUN \
    curl -L https://istio.io/downloadIstio | sh - \
    && mv istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin \
    && rm -rf  istio-${ISTIO_VERSION}

#dapr  Distributed Application Runtime
RUN \
    wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

#karmada Open, Multi-Cloud, Multi-Cluster Kubernetes Orchestration.
RUN \
    wget https://github.com/karmada-io/karmada/releases/download/v1.0.1/kubectl-karmada-linux-amd64.tgz \
    && tar -zxf kubectl-karmada-linux-amd64.tgz \
    && mv kubectl-karmada /usr/local/bin/karmada \
    && rm kubectl-karmada-linux-amd64.tgz

#packer
#ARG PACKER_VERSION=1.7.8
#RUN \
#    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
#    && unzip packer_${PACKER_VERSION}_linux_amd64.zip \
#    && mv packer /usr/local/bin/ \
#    && rm packer_${PACKER_VERSION}_linux_amd64.zip

#terraform
#ARG TERRAFORM_VERSION=1.1.2
#RUN \
#   wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
#   && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
#   && mv terraform /usr/local/bin/ \
#   && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update -y && apt-get install -y packer terraform consul

#aliyun-cli
ARG ALIYUN_CLI_VERSION=3.0.60
RUN \
    wget https://aliyuncli.alicdn.com/aliyun-cli-linux-${ALIYUN_CLI_VERSION}-amd64.tgz \
    && tar -zxvf aliyun-cli-linux-${ALIYUN_CLI_VERSION}-amd64.tgz \
    && mv aliyun /usr/local/bin \
    && rm aliyun-cli-linux-${ALIYUN_CLI_VERSION}-amd64.tgz

#awscli
RUN \
    wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip awscli-exe-linux-x86_64.zip \
    && ./aws/install \
    && rm -rf aws*

#tccli 
RUN pip3 install tccli

#COPY daemon.json /etc/docker/daemon.json
#COPY rootfs /

#tencent cloud COSCMD
RUN \
    pip3 install coscmd -U

#baidu cloud BCE CMD
RUN \
   wget https://bce-doc-on.bj.bcebos.com/bce-documentation/BOS/linux-bcecmd-0.3.1.zip \
   && unzip linux-bcecmd-0.3.1.zip \
   && mv linux-bcecmd-0.3.1/bcecmd /usr/local/bin/ \
   && rm -rf linux-bcecmd*

#dependency-check
RUN \
    wget https://github.com/jeremylong/DependencyCheck/releases/download/v6.5.3/dependency-check-6.5.3-release.zip \
    && unzip dependency-check-6.5.3-release.zip \
    && mv dependency-check /usr/local/ \
    && ln -sf /usr/local/dependency-check/bin/dependency-check.sh  /usr/local/bin/dependency-check \
    && rm -rf dependency-check*

#grype scanner
RUN \
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

#jenkins-x
RUN \
    wget https://github.com/jenkins-x/jx/releases/download/v3.2.248/jx-linux-amd64.tar.gz \
    && tar zxf jx-linux-amd64.tar.gz \
    && mv jx /usr/local/bin/ \
    && rm jx-linux-amd64.tar.gz

#skaffold 
RUN \
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/v1.35.0/skaffold-linux-amd64 \
    && chmod +x skaffold \
    && mv skaffold /usr/local/bin

#draft: A tool for developers to create cloud-native applications on Kubernetes

#Knative client 

RUN \
    wget https://github.com/knative/client/releases/download/knative-v1.2.0/kn-linux-amd64 \
    && chmod +x kn-linux-amd64 \
    && mv kn-linux-amd64 /usr/local/bin/kn

#sealer

RUN \
    wget -c http://sealer.oss-cn-beijing.aliyuncs.com/sealers/sealer-v0.6.1-linux-amd64.tar.gz \
    && tar -xvf sealer-v0.6.1-linux-amd64.tar.gz -C /usr/local/bin \
    && rm sealer-v0.6.1-linux-amd64.tar.gz

#allure report depends on java8-runtime
#RUN \
#    wget https://github.com/allure-framework/allure2/releases/download/2.17.2/allure_2.17.2-1_all.deb \
#    &&dpkg -i allure_2.17.2-1_all.deb \
#    && rm allure_2.17.2-1_all.deb

RUN \
    wget https://github.com/allure-framework/allure2/releases/download/2.17.2/allure-2.17.2.tgz \
    && tar zxf allure-2.17.2.tgz -C /usr/local/ \
    &&  ln -s /usr/local/allure-2.17.2/bin/allure  /usr/local/bin/allure \
    && rm allure-2.17.2.tgz

# jenkins slave
ENV HOME /home/jenkins

RUN groupadd -g 10000 jenkins \
    && useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins -s /bin/bash \
    && usermod -a -G docker jenkins \
    && sed -i '/^root/a\jenkins    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

RUN rm -rf /root/ \
    && ln -sf /home/jenkins /root

LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="4.7"

ARG VERSION=4.14
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

CMD ["jenkins-agent"]
