#upstream https://github.com/kubernetes/contrib/tree/master/statefulsets/kafka
FROM slpcat/jdk:v1.8-alpine
MAINTAINER 若虚 <slpcat@qq.com>

RUN \
    apk update \
    && apk add gnupg

ENV KAFKA_USER=kafka \
KAFKA_DATA_DIR=/var/lib/kafka/data \
KAFKA_HOME=/opt/kafka \
PATH=$PATH:/opt/kafka/bin

ARG KAFKA_VERSION=2.2.2
ARG KAFKA_DIST=kafka_2.12-2.2.2
RUN set -x \
#	&& wget -q "http://www.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_DIST.tgz" \
    && wget "http://archive.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_DIST.tgz" \
    && wget "http://archive.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_DIST.tgz.asc" \
    && wget -q "http://kafka.apache.org/KEYS" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --import KEYS \
#    && gpg --batch --verify "$KAFKA_DIST.tgz.asc" "$KAFKA_DIST.tgz" \
    #&& mkdir /opt \
    && tar -xzf "$KAFKA_DIST.tgz" -C /opt \
    && rm -r "$KAFKA_DIST.tgz" "$KAFKA_DIST.tgz.asc"
    
COPY log4j.properties /opt/$KAFKA_DIST/config/
COPY kafka-server-start.sh /opt/$KAFKA_DIST/bin/

RUN set -x \
    && ln -s /opt/$KAFKA_DIST $KAFKA_HOME \
    && adduser -D $KAFKA_USER \
    && [ `id -u $KAFKA_USER` -eq 1000 ] \
    && [ `id -g $KAFKA_USER` -eq 1000 ] \
    && mkdir -p $KAFKA_DATA_DIR \
    && chown -R "$KAFKA_USER:$KAFKA_USER"  /opt/$KAFKA_DIST \
    && chown -R "$KAFKA_USER:$KAFKA_USER"  $KAFKA_DATA_DIR
WORKDIR /opt/kafka
#ENTRYPOINT ["bin/kafka-server-start.sh"]
