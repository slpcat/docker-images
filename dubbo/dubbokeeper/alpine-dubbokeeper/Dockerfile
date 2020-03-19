FROM  maven:3.5.3 AS build
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list

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

# Install required packages
RUN \
    apt-get upgrade -y

# install from source
RUN \
    git clone https://github.com/dubboclub/dubbokeeper.git

WORKDIR /dubbokeeper
RUN \
    mvn -Dmaven.test.skip=true clean package install -P mysql assembly:assembly -U

FROM slpcat/tomcat8:alpine-8.5
MAINTAINER 若虚 <slpcat@qq.com>

COPY --from=build /dubbokeeper/target/mysql-dubbokeeper-ui/dubbokeeper-ui-1.0.1.war /dubbokeeper-ui-1.0.1.war
RUN \
    rm -rf /usr/local/tomcat/webapps \
    && mkdir -p /usr/local/tomcat/webapps/ROOT \
    && unzip /dubbokeeper-ui-1.0.1.war -d /usr/local/tomcat/webapps/ROOT \
    && sed -i s/DEBUG/INFO/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/logback.xml \
    && rm /dubbokeeper-ui-1.0.1.war

EXPOSE 8080
