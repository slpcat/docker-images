#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM eclipse-temurin:21.0.4_7-jdk-noble

LABEL org.opencontainers.image.authors="slpcat@qq.com"

RUN apt-get update -y             \
    && apt-get upgrade -y         \
    && apt-get install -y         \
       apt-transport-https        \
       binutils                   \
       ethtool                    \
       vim-tiny                   \
       iproute2                   \
       wget                       \
       telnet                     \
       less                       \
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
       vim                  \
       jq                   \
       openssh-client       \
       unzip                \
       zip                  \
       groff                \
       snoopy               \
       clamav               \
       clamav-freshclam     \
       nodejs               \
       npm                  \
       python3              \
       python3-pip          \
       python3-all-venv     \
       python3-pytest
       
COPY pip.conf ld.so.preload snoopy.ini /etc/

#install docker-ce
#RUN \    
#    curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/debian/gpg | apt-key add - && \
#    echo 'deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/debian bullseye stable' > /etc/apt/sources.list.d/docker-ce.list && \
#    apt-get update -y &&\
#    apt-get install -y docker-ce 

# Add Docker's official GPG key:
RUN \
    apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \

# Add the repository to Apt sources:
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
       tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Install AI coding/Vibe coding tools 
# Claude Code , Cursor CLI, CodeX
RUN \
    npm install -g @anthropic-ai/claude-code \
    #curl https://cursor.com/install -fsS | bash \
    #mv $HOME/.local/bin/cursor-agent /usr/local/bin/ \
    npm install -g @openai/codex \
    npm install -g cline
    
#install ansible
RUN \
    apt-get install -y ansible ansible-mitogen

# Environment variables substitution for Go
RUN \
    curl -L https://github.com/a8m/envsubst/releases/download/v1.4.3/envsubst-`uname -s`-`uname -m` -o envsubst && \
    chmod +x envsubst && \
    mv envsubst /usr/local/bin

#Robot Framework is a generic open source automation framework.
RUN \
    pip3 install --break-system-packages robotframework

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
ARG ISTIO_VERSION=1.24.0
RUN \
    curl -L https://istio.io/downloadIstio | sh - \
    && mv istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin \
    && rm -rf  istio-${ISTIO_VERSION}

#Datree prevents Kubernetes misconfigurations from reaching production.
RUN curl https://get.datree.io | /bin/bash

#Terrascan is a static code analyzer for Infrastructure as Code.
RUN \
    curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E "https://.+?_Darwin_x86_64.tar.gz")" > terrascan.tar.gz \
    && tar -xf terrascan.tar.gz terrascan && rm terrascan.tar.gz \
    && install terrascan /usr/local/bin && rm terrascan

#Kubescape is a K8s open-source tool providing a multi-cloud K8s single pane of glass, including risk analysis, security compliance, RBAC visualizer and image vulnerabilities scanning. 
RUN curl -s https://raw.githubusercontent.com/armosec/kubescape/master/install.sh | /bin/bash

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
#RUN pip3 install tccli

#COPY daemon.json /etc/docker/daemon.json
#COPY rootfs /

#tencent cloud COSCMD
#RUN \
#    pip3 install coscmd -U --break-system-packages

#baidu cloud BCE CMD
RUN \
   wget https://bce-doc-on.bj.bcebos.com/bce-documentation/BOS/linux-bcecmd-0.3.1.zip \
   && unzip linux-bcecmd-0.3.1.zip \
   && mv linux-bcecmd-0.3.1/bcecmd /usr/local/bin/ \
   && rm -rf linux-bcecmd*

#dependency-check
RUN \
    wget https://github.com/jeremylong/DependencyCheck/releases/download/v12.1.0/dependency-check-12.1.0-release.zip \
    && unzip dependency-check-12.1.0-release.zip \
    && mv dependency-check /usr/local/ \
    && ln -sf /usr/local/dependency-check/bin/dependency-check.sh  /usr/local/bin/dependency-check \
    && rm -rf dependency-check*

#Cosign
RUN \
    curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64" && \
    mv cosign-linux-amd64 /usr/local/bin/cosign && \
    chmod +x /usr/local/bin/cosign

#https://github.com/notaryproject/notary

#SBOM syft
RUN \
    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

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

#RUN \
#    wget -c http://sealer.oss-cn-beijing.aliyuncs.com/sealers/sealer-v0.6.1-linux-amd64.tar.gz \
#    && tar -xvf sealer-v0.6.1-linux-amd64.tar.gz -C /usr/local/bin \
#    && rm sealer-v0.6.1-linux-amd64.tar.gz

#allure report depends on java8-runtime
#RUN \
#    wget https://github.com/allure-framework/allure2/releases/download/2.17.2/allure_2.17.2-1_all.deb \
#    &&dpkg -i allure_2.17.2-1_all.deb \
#    && rm allure_2.17.2-1_all.deb

RUN \
    wget https://github.com/allure-framework/allure2/releases/download/2.33.0/allure-2.33.0.tgz \
    && tar zxf allure-2.33.0.tgz -C /usr/local/ \
    &&  ln -s /usr/local/allure-2.33.0/bin/allure  /usr/local/bin/allure \
    && rm allure-2.33.0.tgz

# jenkins slave
ENV HOME /home/jenkins

RUN groupadd -g 10000 jenkins \
    && useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins -s /bin/bash \
    && usermod -a -G docker jenkins \
    && sed -i '/^root/a\jenkins    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

RUN rm -rf /root/ \
    && ln -sf /home/jenkins /root

LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="4.7"

ARG VERSION=3301.v4363ddcca_4e7
ARG AGENT_WORKDIR=/home/jenkins/agent

RUN curl --create-dirs -sSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar

ARG user=jenkins

USER root

COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

USER ${user}

ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}

CMD ["jenkins-agent"]
