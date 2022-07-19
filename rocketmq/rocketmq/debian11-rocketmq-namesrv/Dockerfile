#upstream: https://github.com/apache/rocketmq-operator/raw/master/images/namesrv/alpine/Dockerfile
FROM slpcat/oraclejdk:8-bullseye

RUN apt-get update && apt-get install -y gnupg2 unzip

# Rocketmq version
ENV ROCKETMQ_VERSION 4.9.1

# Rocketmq home
ENV ROCKETMQ_HOME  /root/rocketmq/nameserver

WORKDIR  ${ROCKETMQ_HOME}

# Install
RUN set -eux; \
    curl https://archive.apache.org/dist/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip -o rocketmq.zip; \
    curl https://archive.apache.org/dist/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip.asc -o rocketmq.zip.asc; \
    curl -L https://www.apache.org/dist/rocketmq/KEYS -o KEYS; \
    gpg --import KEYS; \
    gpg --batch --verify rocketmq.zip.asc rocketmq.zip; \
    unzip rocketmq.zip; \
    mv rocketmq-all*/* . ; \
    rmdir rocketmq-all* ; \
    rm rocketmq.zip ; \
    rm rocketmq.zip.asc KEYS; \
    rm -rf /tmp/*

# Copy customized scripts
COPY runserver-customize.sh ${ROCKETMQ_HOME}/bin/

# Expose namesrv port
EXPOSE 9876

# Override customized scripts for namesrv
# Export Java options
# Add ${JAVA_HOME}/lib/ext as java.ext.dirs
RUN mv ${ROCKETMQ_HOME}/bin/runserver-customize.sh ${ROCKETMQ_HOME}/bin/runserver.sh \
    && chmod a+x ${ROCKETMQ_HOME}/bin/runserver.sh \
    && chmod a+x ${ROCKETMQ_HOME}/bin/mqnamesrv \
    && export JAVA_OPT=" -Duser.home=/opt" \
    && sed -i 's/${JAVA_HOME}\/jre\/lib\/ext/${JAVA_HOME}\/jre\/lib\/ext:${JAVA_HOME}\/lib\/ext/' ${ROCKETMQ_HOME}/bin/tools.sh

WORKDIR ${ROCKETMQ_HOME}/bin

CMD ["/bin/bash", "mqnamesrv"]
