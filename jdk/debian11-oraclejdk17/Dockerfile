FROM slpcat/debian:bullseye as builder

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

#install JDK 17
ENV JAVA_VERSION=17.0.2 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

COPY --from=builder /usr/lib/jvm /usr/lib/jvm

RUN  \
    ln -s "java-${JAVA_VERSION}-oracle" "$JAVA_HOME" && \
    ln -s "$JAVA_HOME/bin/"* "/usr/bin/"
