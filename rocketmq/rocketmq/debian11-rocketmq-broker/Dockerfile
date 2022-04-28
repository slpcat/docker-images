#upstream: https://github.com/apache/rocketmq-operator/raw/master/images/broker/alpine/Dockerfile
FROM openjdk:8-alpine

RUN apk add --no-cache bash gettext nmap-ncat openssl busybox-extras


# Rocketmq version
ENV ROCKETMQ_VERSION 4.9.1

# Rocketmq home
ENV ROCKETMQ_HOME  /root/rocketmq/broker

WORKDIR  ${ROCKETMQ_HOME}

# Install
RUN set -eux; \
    apk add --virtual .build-deps curl gnupg unzip; \
    curl https://archive.apache.org/dist/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip -o rocketmq.zip; \
    curl https://archive.apache.org/dist/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip.asc -o rocketmq.zip.asc; \
	curl -L https://www.apache.org/dist/rocketmq/KEYS -o KEYS; \
	\
	gpg --import KEYS; \
    gpg --batch --verify rocketmq.zip.asc rocketmq.zip; \
    unzip rocketmq.zip; \
	mv rocketmq-all*/* . ; \
	rmdir rocketmq-all* ; \
	rm rocketmq.zip ; \
	rm rocketmq.zip.asc KEYS; \
	apk del .build-deps ; \
    rm -rf /var/cache/apk/* ; \
    rm -rf /tmp/*

# Copy customized scripts
COPY runbroker-customize.sh ${ROCKETMQ_HOME}/bin/

# Expose broker ports
EXPOSE 10909 10911 10912

# Override customized scripts for broker
RUN mv ${ROCKETMQ_HOME}/bin/runbroker-customize.sh ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod a+x ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod a+x ${ROCKETMQ_HOME}/bin/mqbroker

# Export Java options
RUN export JAVA_OPT=" -Duser.home=/opt"

# Add ${JAVA_HOME}/lib/ext as java.ext.dirs
RUN sed -i 's/${JAVA_HOME}\/jre\/lib\/ext/${JAVA_HOME}\/jre\/lib\/ext:${JAVA_HOME}\/lib\/ext/' ${ROCKETMQ_HOME}/bin/tools.sh

COPY brokerGenConfig.sh brokerStart.sh ${ROCKETMQ_HOME}/bin/

RUN chmod a+x ${ROCKETMQ_HOME}/bin/brokerGenConfig.sh \
 && chmod a+x ${ROCKETMQ_HOME}/bin/brokerStart.sh

WORKDIR ${ROCKETMQ_HOME}/bin

CMD ["/bin/bash", "./brokerStart.sh"]
