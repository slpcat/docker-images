FROM slpcat/centos:7 as builder

MAINTAINER 若虚 <slpcat@qq.com>

#install JDK 8
ENV JAVA_VERSION=8 \
    JAVA_UPDATE=381 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

ARG TARGETARCH

COPY jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-*.tar.gz install_jdk8.sh /tmp/

RUN \
    /tmp/install_jdk8.sh /tmp/

FROM slpcat/centos:7

MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    yum update -y && \
    yum clean all

#install JDK 8
ENV JAVA_VERSION=8 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

COPY --from=builder /usr/lib/jvm /usr/lib/jvm

RUN  \
    ln -s "java-${JAVA_VERSION}-oracle" "$JAVA_HOME" && \
    ln -s "$JAVA_HOME/bin/"* "/usr/bin/"
