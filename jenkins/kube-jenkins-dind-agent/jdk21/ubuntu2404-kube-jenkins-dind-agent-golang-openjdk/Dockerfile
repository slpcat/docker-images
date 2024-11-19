#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/kube-jenkins-dind-agent:openjdk21-ubuntu2404
LABEL org.opencontainers.image.authors="slpcat@qq.com"

USER root

RUN \
    apt-get install -y golang
