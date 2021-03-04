FROM  slpcat/maven:alpine-all AS build
MAINTAINER 若虚 <slpcat@qq.com

RUN apk add git

# install from source
RUN \
    git clone https://github.com/xuxueli/xxl-job.git

WORKDIR /xxl-job
RUN \
    git checkout v2.2.0

COPY pom.xml xxl-job-admin/pom.xml
COPY application.properties xxl-job-admin/src/main/resources/application.properties

RUN  mvn -Dmaven.test.skip=true clean package install

FROM openjdk:8-jre-slim
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN echo 'deb http://mirrors.aliyun.com/debian buster-backports main' > /etc/apt/sources.list.d/backports.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny curl locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

ENV PARAMS=""

RUN mkdir -p /opt/xxl-job-admin/config

COPY --from=build /xxl-job/xxl-job-admin/target/xxl-job-admin-2.2.0.jar /opt/xxl-job-admin/xxl-job-admin-2.2.0.jar

WORKDIR /opt/xxl-job-admin/

ENTRYPOINT ["sh","-c","java -jar $JAVA_OPTS xxl-job-admin-2.2.0.jar $PARAMS"]
