FROM centos:7
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

COPY epel.repo /etc/yum.repos.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

RUN \
    yum update -y && \
    yum install -y wget unzip

#install JDK 1.6.45
ENV JAVA_6_HOME=/usr/lib/jvm/java-6-oracle
COPY jdk-6u45-linux-x64.bin /tmp
RUN \
    cd /tmp \
    && bash jdk-6u45-linux-x64.bin \
    && mkdir -p /usr/lib/jvm \
    && mv jdk1.6.0_45 $JAVA_6_HOME \
    && rm -rf /tmp/*

#install JDK 1.7.80
ENV JAVA_7_HOME=/usr/lib/jvm/java-7-oracle
COPY jdk-7u80-linux-x64.tar.gz /tmp
RUN \
    cd /tmp \
    && tar -xzf jdk-7u80-linux-x64.tar.gz \
    && mv jdk1.7.0_80 $JAVA_7_HOME \
    && rm -rf /tmp/*

#install JDK 1.8.181
ENV JAVA_VERSION=8 \
    JAVA_UPDATE=181 \
    JAVA_BUILD=13 \
    JAVA_PATH=96a7b8442fe848ef90c96a2fad6ed6d1 \
    JAVA_HOME="/usr/lib/jvm/default-jvm" \
    JAVA_8_HOME=/usr/lib/jvm/java-8-oracle

RUN \
    cd "/tmp" && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" && \
    tar -xzf "jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" && \
    mv "/tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}" "/usr/lib/jvm/java-${JAVA_VERSION}-oracle" && \
    ln -s "java-${JAVA_VERSION}-oracle" "$JAVA_HOME" && \
    ln -s "$JAVA_HOME/bin/"* "/usr/bin/" && \
    rm -rf "$JAVA_HOME/"*src.zip && \
    rm -rf "$JAVA_HOME/lib/missioncontrol" \
           "$JAVA_HOME/lib/visualvm" \
           "$JAVA_HOME/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/plugin.jar" \
           "$JAVA_HOME/jre/lib/ext/jfxrt.jar" \
           "$JAVA_HOME/jre/bin/javaws" \
           "$JAVA_HOME/jre/lib/javaws.jar" \
           "$JAVA_HOME/jre/lib/desktop" \
           "$JAVA_HOME/jre/plugin" \
           "$JAVA_HOME/jre/lib/"deploy* \
           "$JAVA_HOME/jre/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/"*jfx* \
           "$JAVA_HOME/jre/lib/amd64/libdecora_sse.so" \
           "$JAVA_HOME/jre/lib/amd64/"libprism_*.so \
           "$JAVA_HOME/jre/lib/amd64/libfxplugins.so" \
           "$JAVA_HOME/jre/lib/amd64/libglass.so" \
           "$JAVA_HOME/jre/lib/amd64/libgstreamer-lite.so" \
           "$JAVA_HOME/jre/lib/amd64/"libjavafx*.so \
           "$JAVA_HOME/jre/lib/amd64/"libjfx*.so && \
    rm -rf "$JAVA_HOME/jre/bin/jjs" \
           "$JAVA_HOME/jre/bin/keytool" \
           "$JAVA_HOME/jre/bin/orbd" \
           "$JAVA_HOME/jre/bin/pack200" \
           "$JAVA_HOME/jre/bin/policytool" \
           "$JAVA_HOME/jre/bin/rmid" \
           "$JAVA_HOME/jre/bin/rmiregistry" \
           "$JAVA_HOME/jre/bin/servertool" \
           "$JAVA_HOME/jre/bin/tnameserv" \
           "$JAVA_HOME/jre/bin/unpack200" \
           "$JAVA_HOME/jre/lib/ext/nashorn.jar" \
           "$JAVA_HOME/jre/lib/jfr.jar" \
           "$JAVA_HOME/jre/lib/jfr" \
           "$JAVA_HOME/jre/lib/oblique-fonts" && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION}/jce_policy-${JAVA_VERSION}.zip" && \
    unzip -jo -d "${JAVA_HOME}/jre/lib/security" "jce_policy-${JAVA_VERSION}.zip" && \
    rm "${JAVA_HOME}/jre/lib/security/README.txt" && \
    rm "/tmp/"*

#install JDK 9 non-LTS
ENV JAVA_9_HOME=/usr/lib/jvm/java-9-oracle
COPY jdk-9.0.4_linux-x64_bin.tar.gz /tmp
RUN \
    cd /tmp \
    && tar -xzf jdk-9.0.4_linux-x64_bin.tar.gz \
    && mv jdk-9.0.4 $JAVA_9_HOME \
    && rm -rf /tmp/*

#install JDK 10 non-LTS
ENV JAVA_10_HOME=/usr/lib/jvm/java-10-oracle
RUN \
    cd "/tmp" \
    && wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_linux-x64_bin.tar.gz" \
    && tar -xzf jdk-10.0.2_linux-x64_bin.tar.gz \
    && mv jdk-10.0.2 $JAVA_10_HOME \
    && rm -rf /tmp/*

#install JDK 11 18.9 LTS
ENV JAVA_11_HOME=/usr/lib/jvm/java-11-oracle
RUN \
    cd "/tmp" \
    && wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jdk/11+28/55eed80b163941c8885ad9298e6d786a/jdk-11_linux-x64_bin.tar.gz" \
    && tar -xzf jdk-11_linux-x64_bin.tar.gz \
    && mv jdk-11 $JAVA_11_HOME \
    && rm -rf /tmp/*

#install JDK 12 EA
#https://download.java.net/java/early_access/jdk12/12/GPL/openjdk-12-ea+12_linux-x64_bin.tar.gz
