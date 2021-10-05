#!/bin/sh
    if [ "$TARGETARCH" == "amd64" ]; then
       export ARCH="x86_64"
    else
       export ARCH=$TARGETARCH
    fi

    wget  https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-${ARCH}.tar.gz
    mkdir -p /etc/filebeat /var/lib/filebeat /var/log/filebeat
    tar zxf /tmp/filebeat-${FILEBEAT_VERSION}-linux-${ARCH}.tar.gz -C /tmp/
    cp -rf /tmp/filebeat-${FILEBEAT_VERSION}-linux-${ARCH}/filebeat /usr/bin/
    cp -rf /tmp/filebeat-${FILEBEAT_VERSION}-linux-${ARCH}/fields.yml /etc/filebeat/
    cp -rf /tmp/filebeat-${FILEBEAT_VERSION}-linux-${ARCH}/kibana /etc/filebeat/
    cp -rf /tmp/filebeat-${FILEBEAT_VERSION}-linux-${ARCH}/module /etc/filebeat/
    cp -rf /tmp/filebeat-${FILEBEAT_VERSION}-linux-${ARCH}/modules.d /etc/filebeat/
