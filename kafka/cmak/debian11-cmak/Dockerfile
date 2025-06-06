#upstream https://github.com/sheepkiller/kafka-manager-docker
FROM slpcat/oraclejdk:11-bullseye as builder
MAINTAINER 若虚 <slpcat@qq.com>

ENV SBT_VERSION=1.3.8 \
    SCALA_VERSION=2.12.10 \
    CMAK_VERSION=3.0.0.6 \
    ZK_HOSTS=localhost:2181

#install scala and sbt
RUN set -xe \
    && apt-get update -y \
    && apt-get dist-upgrade -y \
    #&& wget -q https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.deb -O scala.deb \
    && wget -q https://scala.jfrog.io/artifactory/debian/sbt-$SBT_VERSION.deb -O sbt.deb \
    && dpkg -i sbt.deb \
    && rm sbt.deb \
    && rm -rf /var/lib/apt/lists/*

#change sbt repo
COPY repositories /root/.sbt/repositories

WORKDIR /opt/cmak

RUN set -xe \
    && mkdir src \
    && curl -sSL https://github.com/yahoo/CMAK/archive/$CMAK_VERSION.tar.gz | tar xz --strip 1 -C src \
    && cd src \
    && sbt clean universal:packageZipTarball \
    && cd .. \
    && tar xzf src/target/universal/cmak-$CMAK_VERSION.tgz --strip 1 \
    && rm -rf src

EXPOSE 9000

ENTRYPOINT ["bin/cmak"]
CMD ["-Dconfig.file=conf/application.conf", "-Dhttp.port=9000", "-Dpidfile.path=/dev/null"]
