FROM debian:stretch
MAINTAINER 若虚 <slpcat@qq.com>

ENV \
    TERM=xterm \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TIMEZONE=Asia/Shanghai
    #openjdk8
    #JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \

RUN echo 'deb http://mirrors.aliyun.com/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com\/debian-security/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils curl dialog vim-tiny locales \ 
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

#openjdk8 apt-get install -y openjdk-8-jdk-headless
# Add Oracle Java PPA
RUN \
    apt-get -y update && \
    apt-get -y install software-properties-common apt-transport-https gnupg2 ca-certificates && \
    #add-apt-repository -y ppa:webupd8team/java && \
    echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main' > etc/apt/sources.list.d/webupd8team-ubuntu-java-xenial.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
    apt-get -y update && \
    # Auto-accept the Oracle License
    #echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    #echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get -y install libpq-dev oracle-java8-installer && \
    # Clean up
    rm -f /var/cache/oracle-jdk8-installer/jdk-*.tar.g

