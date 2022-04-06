FROM slpcat/debian:bullseye as builder-jdk8

MAINTAINER 若虚 <slpcat@qq.com>

#install JDK 8
ENV JAVA_VERSION=8 \
    JAVA_UPDATE=321 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

ARG TARGETARCH

COPY jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-*.tar.gz install_jdk8.sh /tmp/

RUN \
    /tmp/install_jdk8.sh /tmp/

FROM slpcat/debian:bullseye as builder-jdk11

MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    rm -rf /var/lib/apt/lists/

#install JDK 11
ENV JAVA_VERSION=11.0.14 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

ARG TARGETARCH

COPY jdk-${JAVA_VERSION}_linux-*_bin.tar.gz install_jdk11.sh /tmp/

RUN \
    /tmp/install_jdk11.sh /tmp/
FROM slpcat/debian:bullseye as builder-jdk17

MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    rm -rf /var/lib/apt/lists/

#install JDK 17
ENV JAVA_VERSION=17.0.2 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

ARG TARGETARCH

COPY jdk-${JAVA_VERSION}_linux-*_bin.tar.gz install_jdk17.sh /tmp/

RUN \
    /tmp/install_jdk17.sh /tmp/

FROM slpcat/debian:bullseye

MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    rm -rf /var/lib/apt/lists/

#install JDK 8
ENV JAVA_VERSION=8 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

COPY --from=builder-jdk8 /usr/lib/jvm /usr/lib/jvm
COPY --from=builder-jdk11 /usr/lib/jvm /usr/lib/jvm
COPY --from=builder-jdk17 /usr/lib/jvm /usr/lib/jvm

RUN  \
    unlink $JAVA_HOME && \
    ln -sf "java-${JAVA_VERSION}-oracle" "$JAVA_HOME" && \
    ln -sf "$JAVA_HOME/bin/"* "/usr/bin/"
