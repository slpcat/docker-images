FROM slpcat/centos:7 AS builder
MAINTAINER 若虚 <slpcat@qq.com>
#https://nginx.org/en/docs/configure.html

RUN \
    yum install -y \
        git \
        gcc \
        wget \
        make \
        gnupg2 \
        unzip \
        rpm-build

RUN \
     yum -y install ruby ruby-devel rubygems \
     && gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
     && gem install fpm

COPY *.sh /

ARG PKG_ROOT=/fpm_install


ARG NODE_EXPORTER_VERSION=1.0.0-rc.0


COPY node_exporter* /

# Set up certificates, base tools, and Consul.
RUN set -eux && \
    mkdir -p $PKG_ROOT/usr/local/bin && \
    tar -zxC /tmp/ -f node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz && \
    mv /tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter $PKG_ROOT/usr/local/bin && \
    install -m644 -D /node_exporter.service $PKG_ROOT/usr/lib/systemd/system/node_exporter.service

RUN \
    fpm -f --verbose \
    -n node_exporter \ 
    -s dir \
    --iteration 1.el7 \
    -v ${NODE_EXPORTER_VERSION} \
    -t rpm \
    -m node_exporter \
    --vendor node_exporter \
    -a native \
    -p /root/ \
    -C $PKG_ROOT \
    --description 'Exporter for machine metrics' \
    #--conflicts 'nginx,tegine.openresty,kong' \
    --url 'https://github.com/prometheus/node_exporter' \
    #--before-install /before-install.sh \
    --after-install /after-install.sh \
    --before-remove /before-remove.sh
    #--after-remove /after-remove.sh \
    #--config-files /etc/consul.d/

FROM slpcat/centos:7
COPY --from=builder /root/node_exporter-1.0.0_rc.0-1.el7.x86_64.rpm /root
RUN yum install -y /root/node_exporter-1.0.0_rc.0-1.el7.x86_64.rpm /root


#EXPOSE 9100

