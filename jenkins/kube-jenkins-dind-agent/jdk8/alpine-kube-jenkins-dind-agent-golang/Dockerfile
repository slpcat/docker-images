#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/kube-jenkins-dind-agent
MAINTAINER 若虚 <slpcat@qq.com>

USER root

RUN apk add git mercurial binutils bison gcc make go musl-dev openssl tree rsync

#install gvm
COPY go_install.sh /go_install.sh
COPY gvm-installer /gvm-installer

USER jenkins

RUN \
    #curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer|bash \
    bash -x /gvm-installer \
    && bash -x /go_install.sh
