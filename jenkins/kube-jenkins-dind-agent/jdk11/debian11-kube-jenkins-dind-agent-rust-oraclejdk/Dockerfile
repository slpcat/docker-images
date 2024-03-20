#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/kube-jenkins-dind-agent:oraclejdk11-bullseye
MAINTAINER 若虚 <slpcat@qq.com>

USER root

RUN \
    apt-get install -y curl build-essential gcc make \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh \
    && rustup completions bash > /usr/share/bash-completion/completions/rustup
