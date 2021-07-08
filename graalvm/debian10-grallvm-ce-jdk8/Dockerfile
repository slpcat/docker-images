FROM debian:stable-slim
LABEL maintainer="Piotr Findeisen <piotr.findeisen@gmail.com>"

ARG GRAAL_VERSION
ARG JDK_VERSION

RUN set -xeu && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates `# stays, not having this is just not useful` \
        curl \
        && \
    mkdir /graalvm && \
    curl -fsSL "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-${JDK_VERSION}-linux-amd64-${GRAAL_VERSION}.tar.gz" \
        | tar -zxC /graalvm --strip-components 1 && \
    find /graalvm -name "*src.zip"  -printf "Deleting %p\n" -exec rm {} + && \
    { test ! -d /graalvm/legal || tar czf /graalvm/legal.tgz /graalvm/legal/; } && \
    { test ! -d /graalvm/legal || rm -r /graalvm/legal; } && \
    rm -rf /graalvm/man `# does not exist in java11 package` && \
    echo Cleaning up... && \
    apt-get remove -y \
        curl \
        && \
    apt-get autoremove -y && \
    apt-get clean && rm -r "/var/lib/apt/lists"/* && \
    echo 'PATH="/graalvm/bin:$PATH"' | install --mode 0644 /dev/stdin /etc/profile.d/graal-on-path.sh && \
    echo OK

# This applies to all container processes. However, `bash -l` will source `/etc/profile` and set $PATH on its own. For this reason, we
# *also* set $PATH in /etc/profile.d/*
ENV PATH=/graalvm/bin:$PATH

# vim:set tw=140:



# Install GraalVM
RUN curl -fsSL https://github.com/oracle/graal/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-linux-amd64-${GRAALVM_VERSION}.tar.gz > graalvm-ce-${GRAALVM_VERSION}.tar.gz && \
    tar -xvf graalvm-ce-${GRAALVM_VERSION}.tar.gz && \
    rm -f graalvm-ce-${GRAALVM_VERSION}.tar.gz && \
    mv graalvm-ce-${GRAALVM_VERSION} /usr/lib/jvm/ && \
    cd /usr/lib/jvm && \
    ln -sfn graalvm-ce-${GRAALVM_VERSION} graalvm && \
    alternatives --install /usr/bin/java java ${GRAALVM_HOME}bin/java 97

RUN printenv
RUN ${GRAALVM_HOME}bin/gu install native-image
