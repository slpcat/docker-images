#!/bin/bash
set -e 
    if [ "$TARGETARCH" == "amd64" ]; then
       export ARCH="x64"
    fi

    if [ "$TARGETARCH" == "arm64" ]; then
       export ARCH="aarch64"
    fi

    cd "/tmp"
    tar -xzf "jdk-${JAVA_VERSION}_linux-${ARCH}_bin.tar.gz"
    mkdir -p "/usr/lib/jvm" 
    mv "/tmp/jdk-${JAVA_VERSION}" "/usr/lib/jvm/java-${JAVA_VERSION}-oracle" 
    ln -s "java-${JAVA_VERSION}-oracle" "$JAVA_HOME" 
    ln -s "$JAVA_HOME/bin/"* "/usr/bin/"
    rm ${JAVA_HOME}/lib/src.zip
