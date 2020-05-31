#upstream https://github.com/maauso/docker/tree/master/zkui
FROM java:7
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com\/debian-security/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

ENV ENV OTA_EXPORTER_JAEGER_ENDPOINT=localhost:14250 \
    OTA_EXPORTER_JAEGER_SERVICE_NAME=my-zookeeper-ui

RUN apt-get update && apt-get install -y git maven
RUN git clone https://github.com/DeemOpen/zkui.git
RUN cd /zkui && mvn install
WORKDIR /zkui/target/

COPY config.cfg /zkui/target/
COPY entrypoint.sh /zkui/target/
COPY *.jar /zkui/target/

RUN chmod +x entrypoint.sh
EXPOSE 9090
ENTRYPOINT ["./entrypoint.sh"]
CMD ["/usr/bin/java", "-javaagent:/zkui/target/opentelemetry-auto-0.3.0.jar", "-Dota.exporter.jar=/zkui/target/opentelemetry-auto-exporters-jaeger-0.3.0.jar", "-jar", "/zkui/target/zkui-2.0-SNAPSHOT-jar-with-dependencies.jar"]


FROM java:8

MAINTAINER Miguel Garcia Puyol <miguelpuyol@gmail.com>

WORKDIR /var/app

ADD zkui-*.jar /var/app/zkui.jar
ADD config.cfg /var/app/config.cfg
ADD bootstrap.sh /var/app/bootstrap.sh

ENTRYPOINT ["/var/app/bootstrap.sh"]

EXPOSE 9090

