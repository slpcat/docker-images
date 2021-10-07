#!/bin/bash
set -e
    if [ "$TARGETARCH" == "amd64" ]; then
       export ARCH="amd64"
    fi

    if [ "$TARGETARCH" == "arm64" ]; then
       export ARCH="aarch64"
    fi

    wget -O /tmp/s6-overlay.tar.gz https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${ARCH}.tar.gz
    tar xvfz /tmp/s6-overlay.tar.gz -C / && rm /tmp/s6-overlay.tar.gz && ln -sf /usr/bin/bash /bin/sh && ln -sf /usr/bin/bash /bin/bash
