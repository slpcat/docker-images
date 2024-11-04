from openjdk:8u282-slim

ENV KE_HOME=/opt/kafka-eagle
ENV EAGLE_VERSION=2.0.3

#ADD system-config.properties /tmp

COPY kafka-eagle-web-${EAGLE_VERSION}-bin.tar.gz  /tmp

RUN mkdir -p /opt/kafka-eagle/conf

RUN tar zxvf /tmp/kafka-eagle-web-${EAGLE_VERSION}-bin.tar.gz -C /opt/kafka-eagle --strip-components 1 && \
    chmod +x /opt/kafka-eagle/bin/ke.sh && \
    mkdir -p /hadoop/kafka-eagle/db

EXPOSE 8048 8080

COPY system-config.properties /opt/kafka-eagle/conf/system-config.properties
COPY entrypoint.sh /opt/kafka-eagle/bin/entrypoint.sh

RUN chmod +x /opt/kafka-eagle/bin/entrypoint.sh

WORKDIR /opt/kafka-eagle

CMD ["sh", "/opt/kafka-eagle/bin/entrypoint.sh"]
