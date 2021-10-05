#!/bin/sh
    if [ "$TARGETARCH" == "amd64" ]; then
       export ARCH="x86_64"
    else
       export ARCH=$TARGETARCH
    fi

    wget  https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-${ARCH}.tar.gz
    tar xzvf filebeat-${FILEBEAT_VERSION}-linux-${ARCH}.tar.gz
    mv filebeat-${FILEBEAT_VERSION}-linux-${ARCH}/filebeat /usr/bin/filebeat
    rm -rf filebeat-${FILEBEAT_VERSION}-linux-${ARCH}*
