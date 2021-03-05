# upsteam https://github.com/mesosphere/dcos-jenkins-service
FROM jenkins/jenkins:lts-alpine

MAINTAINER 若虚 <slpcat@qq.com>

USER root

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

# Set timezone and locales
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add \
           bash \
           tzdata \
           vim \
           tini \
           su-exec \
           gzip \
           tar \
           wget \
           curl \
    && echo "${TIMEZONE}" > /etc/TZ \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    # Network fix
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

# Here we install GNU libc (aka glibc) and set en_US.UTF-8 locale as default.

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.27-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget \
        "https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

WORKDIR /tmp

# Environment variables used throughout this Dockerfile
#
# $JENKINS_HOME     will be the final destination that Jenkins will use as its
#                   data directory. This cannot be populated before Marathon
#                   has a chance to create the host-container volume mapping.
#
ENV JENKINS_FOLDER /usr/share/jenkins

# Build Args
ARG BLUEOCEAN_VERSION=latest
ARG JENKINS_STAGING=/usr/share/jenkins/ref/
ARG CURL_RETRY=20
ARG CURL_RETRY_MAX_TIME=900

# install dependencies
RUN \
    apk update    \
    && apk add    \
       python     \
       jq         \
       git        \
       bzip2                \
       openssh-client       \
       unzip                \
       zip

# Override the default property for DNS lookup caching
RUN echo 'networkaddress.cache.ttl=60' >> ${JAVA_HOME}/jre/lib/security/java.security

RUN mkdir -p "$JENKINS_HOME" "${JENKINS_FOLDER}/war"

# jenkins setup
COPY conf/jenkins/config.xml "${JENKINS_STAGING}/config.xml"
#COPY conf/jenkins/jenkins.model.JenkinsLocationConfiguration.xml "${JENKINS_STAGING}/jenkins.model.JenkinsLocationConfiguration.xml"
#COPY conf/jenkins/nodeMonitors.xml "${JENKINS_STAGING}/nodeMonitors.xml"
#COPY conf/jenkins/hudson.model.UpdateCenter.xml "${JENKINS_HOME}/hudson.model.UpdateCenter.xml"
# lets configure Jenkins with some defaults
#COPY config/*.xml /usr/share/jenkins/ref/

# add plugins
RUN /usr/local/bin/install-plugins.sh       \
  blueocean-autofavorite:latest             \
  blueocean-commons:${BLUEOCEAN_VERSION}    \
  blueocean-config:${BLUEOCEAN_VERSION}     \
  blueocean-dashboard:${BLUEOCEAN_VERSION}  \
  blueocean-display-url:latest              \
  blueocean-events:${BLUEOCEAN_VERSION}     \
  blueocean-git-pipeline:${BLUEOCEAN_VERSION}          \
  blueocean-github-pipeline:${BLUEOCEAN_VERSION}       \
  blueocean-i18n:${BLUEOCEAN_VERSION}       \
  blueocean-jwt:${BLUEOCEAN_VERSION}        \
  blueocean-personalization:${BLUEOCEAN_VERSION}    \
  blueocean-pipeline-api-impl:${BLUEOCEAN_VERSION}  \
  blueocean-pipeline-editor:${BLUEOCEAN_VERSION}           \
  blueocean-pipeline-scm-api:${BLUEOCEAN_VERSION}   \
  blueocean-rest-impl:${BLUEOCEAN_VERSION}  \
  blueocean-rest:${BLUEOCEAN_VERSION}       \
  blueocean-web:${BLUEOCEAN_VERSION}        \
  blueocean:${BLUEOCEAN_VERSION}            \
  ace-editor:latest              \
  android-emulator:latest        \
  android-lint:latest            \
  ant:latest                     \
  analysis-core:latest           \
  ansible:latest                 \
  ansicolor:latest               \
  antisamy-markup-formatter:latest \
  artifactory:latest             \
  audit-trail:latest             \
  authentication-tokens:latest   \
  azure-credentials:latest       \
  azure-vm-agents:latest         \
  bouncycastle-api:latest        \
  branch-api:latest              \
  build-failure-analyzer:latest  \
  build-name-setter:latest       \
  build-pipeline-plugin:latest   \
  build-timeout:latest           \
  build-token-root:latest        \
  cloudbees-folder:latest        \
  credentials:latest             \
  credentials-binding:latest     \
  cloverphp:latest               \
  conditional-buildstep:latest   \
  config-file-provider:latest    \
  copyartifact:latest            \
  cvs:latest                     \
  dashboard-view:latest          \
  delivery-pipeline-plugin:latest \
  description-setter:latest      \
  dingding-notifications:latest  \
  display-url-api:latest         \
  docker-commons:latest          \
  docker-build-publish:latest    \
  docker-workflow:latest         \
  durable-task:latest            \
  ec2:latest                     \
  email-ext:latest               \
  embeddable-build-status:latest \
  external-monitor-job:latest    \
  favorite:latest                \
  ghprb:latest                   \
  git:latest                     \
  git-client:latest              \
  git-changelog:latest           \
  git-server:latest              \
  github:latest                  \
  github-api:latest              \
  github-branch-source:latest    \
  github-issues:latest           \
  github-oauth:latest            \
  github-organization-folder:latest \
  github-pullrequest:latest      \
  github-pr-coverage-status:latest \
  gitlab:latest                  \
  gitlab-hook:latest             \
  gitlab-merge-request-jenkins:latest \
  gitlab-oauth:latest            \
  gitlab-plugin:latest           \
  google-login:latest            \
  gradle:latest                  \
  gravatar:latest                \
  greenballs:latest              \
  handlebars:latest              \
  icon-shim:latest               \
  ivy:latest                     \
  jackson2-api:latest            \
  javadoc:latest                 \
  jenkins-multijob-plugin:latest \
  job-dsl:latest                 \
  jobConfigHistory:latest        \
  jquery:latest                  \
  junit:latest                   \
  kerberos-sso:latest            \
  kpp-management-plugin:latest   \
  kubernetes:latest              \
  kubernetes-ci:latest           \
  kubernetes-cd:latest           \
  kubernetes-pipeline-steps:latest \
  ldap:latest                    \
  mailer:latest                  \
  mapdb-api:latest               \
  marathon:latest                \
  matrix-auth:latest             \
  matrix-project:latest          \
  maven-plugin:latest            \
  mercurial:latest               \
  mesos:latest                   \
  metrics:latest                 \
  momentjs:latest                \
  monitoring:latest              \
  msbuild:latest                 \
  nant:latest                    \
  node-iterator-api:latest       \
  oauth-credentials:latest       \
  oic-auth:latest                \
  openid:latest                  \
  openshift-login:latest         \
  openshift-pipeline:latest      \
  pam-auth:latest                \
  parameterized-trigger:latest   \
  performance:latest             \
  pipeline-build-step:latest     \
  pipeline-github-lib:latest     \
  pipeline-githubnotify-step:latest \
  pipeline-graph-analysis:latest \
  pipeline-input-step:latest     \
  pipeline-milestone-step:latest \
  pipeline-model-api:latest      \
  pipeline-model-definition:latest \
  pipeline-model-extensions:latest \
  pipeline-rest-api:latest       \
  pipeline-stage-step:latest     \
  pipeline-stage-tags-metadata:latest \
  pipeline-stage-view:latest     \ 
  pipeline-utility-steps:latest  \
  plain-credentials:latest       \
  postbuildscript:latest         \
  publish-over-cifs:latest       \
  publish-over-ftp:latest        \
  publish-over-ssh:latest        \
  pubsub-light:latest            \
  puppet:latest                  \ 
  rebuild:latest                 \
  resource-disposer:latest       \
  role-strategy:latest           \
  run-condition:latest           \
  s3:latest                      \
  saferestart:latest             \
  saml:latest                    \
  saltstack:latest               \
  scm-api:latest                 \
  script-security:latest         \
  sse-gateway:latest             \
  ssh-agent:latest               \
  ssh-credentials:latest         \
  ssh-slaves:latest              \
  slave-setup:latest             \
  structs:latest                 \
  subversion:latest              \
  timestamper:latest             \
  token-macro:latest             \
  translation:latest             \
  uno-choice:latest              \
  url-auth-sso:latest            \
  variant:latest                 \
  view-job-filters:latest        \
  windows-slaves:latest          \
  workflow-aggregator:latest     \
  workflow-api:latest            \
  workflow-basic-steps:latest    \
  workflow-cps:latest            \
  workflow-cps-global-lib:latest \
  workflow-durable-task-step:latest \
  workflow-job:latest            \
  workflow-multibranch:latest    \
  workflow-scm-step:latest       \
  workflow-step-api:latest       \
  workflow-support:latest        \
  ws-cleanup:latest              \
  xcode-plugin:latest

# copy custom built plugins
COPY plugins/*.hpi /usr/share/jenkins/ref/plugins/

# so we can use jenkins cli
#COPY config/jenkins.properties /usr/share/jenkins/ref/

# disable first-run wizard
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# remove executors in master
COPY src/main/docker/master-executors.groovy /usr/share/jenkins/ref/init.groovy.d/

# ENV JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties"
ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -XshowSettings:vm \
	-Djenkins.install.runSetupWizard=false -Dhudson.udp=-1 -Djava.awt.headless=true -Dhudson.DNSMultiCast.disabled=true"
ENV JENKINS_OPTS="--webroot=${JENKINS_FOLDER}/war --httpListenAddress=0.0.0.0"
