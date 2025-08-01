#upstream: https://github.com/jenkinsci/docker
FROM eclipse-temurin:21.0.4_7-jdk-noble

LABEL org.opencontainers.image.authors="slpcat@qq.com"

# Container variables
ENV \
    TERM="xterm-256color" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y binutils ethtool vim-tiny net-tools iproute2 procps curl wget telnet less && \
    rm -rf /var/lib/apt/lists/

ARG TARGETARCH
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y git curl wget openssh-client unzip jq groff python3 fonts-wqy-microhei snoopy

COPY pip.conf ld.so.preload snoopy.ini /etc/

ARG user=jenkins
ARG group=jenkins
ARG uid=2000
ARG gid=2000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home

ENV JENKINS_HOME=$JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT=${agent_port}

# Jenkins is run with user `jenkins`, uid = 2000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN mkdir -p $JENKINS_HOME \
    && chown ${uid}:${gid} $JENKINS_HOME \
    && groupadd --gid ${gid} ${group} \
    && useradd --home "$JENKINS_HOME" --uid ${uid} --gid ${gid} --shell /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME $JENKINS_HOME

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

# jenkins version being bundled in this docker image
#ENV JENKINS_VERSION ${JENKINS_VERSION:-2.150.1}

# jenkins.war checksum, download will be validated using it
#ARG JENKINS_SHA=d8ed5a7033be57aa9a84a5342b355ef9f2ba6cdb490db042a6d03efb23ca1e83

# Can be used to customize where jenkins.war get downloaded from
#http://mirrors.jenkins.io/war-stable/latest/jenkins.war
#ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war
ARG JENKINS_URL=http://mirrors.jenkins.io/war-stable/latest/jenkins.war
#ARG JENKINS_URL=http://mirrors.jenkins.io/war/latest/jenkins.war
#ARG JENKINS_URL=https://mirrors.aliyun.com/jenkins/war/latest/jenkins.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war
#  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -

#ENV JENKINS_UC https://updates.jenkins.io
#ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_UC_EXPERIMENTAL=https://mirrors.aliyun.com/jenkins/updates/experimental \
    JENKINS_UC=https://mirrors.aliyun.com/jenkins/updates \
    JENKINS_UC_DOWNLOAD=https://mirrors.aliyun.com/jenkins

RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE ${http_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

ENV COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log

USER ${user}

COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
USER root
WORKDIR /tmp

# Environment variables used throughout this Dockerfile
#
# $JENKINS_HOME     will be the final destination that Jenkins will use as its
#                   data directory. This cannot be populated before Marathon
#                   has a chance to create the host-container volume mapping.
#
ENV JENKINS_FOLDER=/usr/share/jenkins

# Build Args
ARG BLUEOCEAN_VERSION=latest
ARG JENKINS_STAGING=/usr/share/jenkins/ref/
ARG CURL_RETRY=20
ARG CURL_RETRY_MAX_TIME=900

# Override the default property for DNS lookup caching
#RUN echo 'networkaddress.cache.ttl=60' >> ${JAVA_HOME}/jre/lib/security/java.security

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
  #blueocean-autofavorite:${BLUEOCEAN_VERSION}             \
  #blueocean-commons:${BLUEOCEAN_VERSION}    \
  #blueocean-config:${BLUEOCEAN_VERSION}     \
  #blueocean-dashboard:${BLUEOCEAN_VERSION}  \
  #blueocean-display-url:${BLUEOCEAN_VERSION}              \
  #blueocean-events:${BLUEOCEAN_VERSION}     \
  #blueocean-git-pipeline:${BLUEOCEAN_VERSION}          \
  #blueocean-github-pipeline:${BLUEOCEAN_VERSION}       \
  #blueocean-i18n:${BLUEOCEAN_VERSION}       \
  #blueocean-jira:${BLUEOCEAN_VERSION}       \
  #blueocean-jwt:${BLUEOCEAN_VERSION}        \
  #blueocean-personalization:${BLUEOCEAN_VERSION}    \
  #blueocean-pipeline-api-impl:${BLUEOCEAN_VERSION}  \
  #blueocean-pipeline-editor:${BLUEOCEAN_VERSION}           \
  #blueocean-pipeline-scm-api:${BLUEOCEAN_VERSION}   \
  #blueocean-rest-impl:${BLUEOCEAN_VERSION}  \
  #blueocean-rest:${BLUEOCEAN_VERSION}       \
  #blueocean-web:${BLUEOCEAN_VERSION}        \
  #blueocean:${BLUEOCEAN_VERSION}            \
  #ace-editor:latest                         \
  active-directory:latest                   \
  #aliyun-oss-uploader:latest                \
  #alibabacloud-credentials:latest           \
  #alibabacloud-ecs:latest                   \
  allure-jenkins-plugin:latest              \
  #amazon-ecr:latest                         \
  #android-emulator:latest        \
  ant:latest                     \
  ansible:latest                 \
  ansicolor:latest               \
  antisamy-markup-formatter:latest \
  artifactory:latest             \
  #artifact-qr-code-plugin:latest   \
  audit-trail:latest             \
  authentication-tokens:latest   \
  #azure-acs:latest               \
  #azure-credentials:latest       \
  #azure-container-registry-tasks \
  #azure-vm-agents:latest         \
  #bouncycastle-api:latest        \
  #branch-api:latest              \
  build-monitor-plugin:latest    \
  build-name-setter:latest       \
  built-on-column:latest         \
  build-pipeline-plugin:latest   \
  build-timeout:latest           \
  build-token-root:latest        \
  build-with-parameters:latest   \
  credentials:latest             \
  credentials-binding:latest     \
  #cloverphp:latest               \
  cloud-stats:latest             \
  #cloudbees-folder:latest        \
  cloudbees-disk-usage-simple:latest \
  command-launcher:latest        \
  conditional-buildstep:latest   \
  config-file-provider:latest    \
  configuration-as-code:latest   \
  configurationslicing:latest    \
  #copy-to-slave:latest          \
  copyartifact:latest            \
  convert-to-pipeline:latest     \
  #cvs:latest                    \
  dark-theme:latest              \
  dashboard-view:latest          \
  delivery-pipeline-plugin:latest \
  dependency-check-jenkins-plugin:latest \
  dependency-track:latest        \
  description-setter:latest      \
  declarative-pipeline-migration-assistant:latest \
  dingding-notifications:latest  \
  dingding-json-pusher:latest    \
  display-url-api:latest         \
  docker-commons:latest          \
  docker-compose-build-step:latest \
  docker-build-publish:latest    \
  docker-build-step:latest       \
  docker-workflow:latest         \
  durable-task:latest            \
  #ec2:latest                     \
  echarts-api:latest             \
  #ecutest:latest                 \
  email-ext:latest               \
  embeddable-build-status:latest \
  envinject:latest               \
  external-monitor-job:latest    \
  extended-choice-parameter:latest \
  extensible-choice-parameter:latest \
  favorite:latest                \
  font-awesome-api:latest        \
  #gerrit-trigger:latest          \
  generic-webhook-trigger:latest \
  ghprb:latest                   \
  git:latest                     \
  git-client:latest              \
  git-changelog:latest           \
  git-parameter:latest           \
  git-server:latest              \
  gitee:latest                   \
  github:latest                  \
  github-api:latest              \
  github-branch-source:latest    \
  #github-checks-plugin:latest    \
  github-issues:latest           \
  github-oauth:latest            \
  #github-pullrequest:latest      \
  github-pr-coverage-status:latest \
  gitlab:latest                  \
  #gitlab-hook:latest             \
  gitlab-merge-request-jenkins:latest \
  gitlab-oauth:latest            \
  gitlab-plugin:latest           \
  global-build-stats:latest      \
  global-post-script:latest      \
  global-pre-script:latest       \
  gradle:latest                  \
  gravatar:latest                \
  #greenballs:latest              \
  groovy:latest                  \
  groovy-postbuild:latest        \
  #handlebars:latest              \
  #huaweicloud-credentials:latest \
  #icon-shim:latest               \
  ivy:latest                     \
  jackson2-api:latest            \
  jacoco:latest                  \
  javadoc:latest                 \
  jira:latest                    \
  jira-trigger:latest            \
  #jenkins-multijob-plugin:latest \
  jobConfigHistory:latest        \
  job-dsl:latest                 \
  job-import-plugin:latest       \
  jquery:latest                  \
  junit:latest                   \
  #kerberos-sso:latest           \
  kpp-management-plugin:latest   \
  kubernetes:latest              \
  kubernetes-credentials-provider:latest \
  #kubernetes-cd:latest           \
  kubernetes-cli:latest          \
  ldap:latest                    \
  #localization-support:latest    \
  localization-zh-cn:latest      \
  mac:latest                     \
  #machine-learning:latest        \
  mailer:latest                  \
  mapdb-api:latest               \
  #marathon:latest               \
  matrix-auth:latest             \
  matrix-project:latest          \
  maven-plugin:latest            \
  #maven-deploy-plugin:latest     \
  #maven-release-plugin:latest    \
  #mercurial:latest              \
  #mesos:latest                  \
  metrics:latest                 \
  #momentjs:latest                \
  monitoring:latest              \
  #msbuild:latest                 \
  nant:latest                    \
  nexus-artifact-uploader:latest \
  nexus-jenkins-plugin:latest    \
  node-iterator-api:latest       \
  nodejs:latest                  \
  nomad:latest                   \
  #nomad-pipeline:latest          \
  oauth-credentials:latest       \
  oic-auth:latest                \
  #openshift-login:latest         \
  packer:latest                  \
  pam-auth:latest                \
  parameterized-trigger:latest   \
  performance:latest             \
  periodicbackup:latest          \
  pipeline-aws:latest            \
  pipeline-build-step:latest     \
  pipeline-github-lib:latest     \
  pipeline-githubnotify-step:latest \
  pipeline-groovy-lib:latest     \
  pipeline-input-step:latest     \
  pipeline-milestone-step:latest \
  pipeline-multibranch-defaults:latest \
  pipeline-model-api:latest      \
  pipeline-model-definition:latest \
  pipeline-model-extensions:latest \
  pipeline-maven:latest          \
  pipeline-rest-api:latest       \
  pipeline-stage-step:latest     \
  pipeline-stage-tags-metadata:latest \
  pipeline-stage-view:latest     \ 
  pipeline-utility-steps:latest  \
  plain-credentials:latest       \
  platformlabeler:latest         \
  plugin-util-api:latest         \
  postbuildscript:latest         \
  postbuild-task:latest          \
  prometheus:latest              \
  #publish-over-cifs:latest       \
  #publish-over-ftp:latest        \
  #publish-over-ssh:latest        \
  #pubsub-light:latest            \
  #puppet:latest                  \ 
  #python:latest                  \
  #python-wrapper:latest          \
  rebuild:latest                 \
  remote-file:latest             \
  report-info:latest             \
  resource-disposer:latest       \
  robot:latest                   \
  role-strategy:latest           \
  run-condition:latest           \
  run-selector:latest            \
  s3:latest                      \
  saferestart:latest             \
  saml:latest                    \
  saltstack:latest               \
  scm-api:latest                 \
  #scp:latest                     \
  script-security:latest         \
  #sse-gateway:latest             \
  ssh:latest                     \
  #ssh-agent:latest               \
  #ssh-credentials:latest         \
  #ssh-slaves:latest              \
  #ssh-steps:latest               \
  #ssh2easy:latest                \
  slave-setup:latest             \
  sonar:latest                   \
  strict-crumb-issuer:latest     \
  structs:latest                 \
  #subversion:latest              \
  terraform:latest               \
  timestamper:latest             \
  thinBackup:latest              \
  throttle-concurrents:latest    \
  token-macro:latest             \
  #translation:latest             \
  uno-choice:latest              \
  #upload-pgyer:latest            \
  url-auth-sso:latest            \
  variant:latest                 \
  view-cloner:latest             \
  view-job-filters:latest        \
  warnings-ng:latest             \
  webhook-step:latest            \
  #windows-slaves:latest          \
  windows-cloud:latest           \
  workflow-aggregator:latest     \
  workflow-api:latest            \
  workflow-basic-steps:latest    \
  #workflow-cps:latest            \
  #workflow-cps-global-lib:latest \
  workflow-durable-task-step:latest \
  workflow-job:latest            \
  workflow-multibranch:latest    \
  workflow-scm-step:latest       \
  workflow-step-api:latest       \
  workflow-support:latest        \
  ws-cleanup:latest              \
  xcode-plugin:latest

# copy custom built plugins
#COPY plugins/*.hpi /usr/share/jenkins/ref/plugins/

# so we can use jenkins cli
#COPY config/jenkins.properties /usr/share/jenkins/ref/

# disable first-run wizard
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# remove executors in master
COPY src/main/docker/master-executors.groovy /usr/share/jenkins/ref/init.groovy.d/

# ENV JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties"
ENV JAVA_OPTS="-server -Djava.awt.headless=true -XshowSettings:vm \
         -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m -XX:ReservedCodeCacheSize=240M \
         -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions \
         -XX:-UseLargePages -XX:SoftRefLRUPolicyMSPerMB=0 \
         -XX:ConcGCThreads=2 -XX:ParallelGCThreads=8 \
         -XX:+UseZGC -XX:+ZGenerational -XX:+DisableExplicitGC \
         -XX:-OmitStackTraceInFastThrow -XX:+ParallelRefProcEnabled \
         -XX:MaxTenuringThreshold=1 \
         -XX:-ResizePLAB -XX:+UseStringDeduplication \
         -Djenkins.install.runSetupWizard=false \
         -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true \
         -Dorg.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH=true \
         -Dhudson.udp=-1 -Dfile.encoding=UTF-8 \
         -Dorg.csanchez.jenkins.plugins.kubernetes.clients.cacheExpiration=60 \
         -Dhudson.model.LoadStatistics.clock=2000 \
         -Dhudson.model.LoadStatistics.decay=0.5 \
         -Dhudson.slaves.NodeProvisioner.recurrencePeriod=5000 \
         -Dhudson.slaves.NodeProvisioner.initialDelay=0 \
         -Dhudson.slaves.NodeProvisioner.MARGIN=50 \
         -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85 \
         -Dhudson.DNSMultiCast.disabled=true"

ENV JENKINS_OPTS="--webroot=${JENKINS_FOLDER}/war --httpListenAddress=0.0.0.0"

# Add Tini
ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

CMD ["/usr/local/bin/jenkins.sh"]
