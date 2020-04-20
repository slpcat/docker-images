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

RUN \
    bash before-install.sh

ARG PKG_ROOT=/fpm_install


# This is the release of Consul to pull in.
ARG CONSUL_VERSION=1.7.2

# This is the location of the releases.
ENV HASHICORP_RELEASES=https://releases.hashicorp.com

ARG consulArch=amd64

COPY consul_*.zip /
COPY consul.service  /

# Set up certificates, base tools, and Consul.
RUN set -eux && \
    #gpg --keyserver keyserver.ubuntu.com --recv-keys 91A6E7F85D05C65630BEF18951852D87348FFC4C && \
    #mkdir -p /tmp/build && \
    #cd /tmp/build && \
    #wget ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${consulArch}.zip && \
    #wget ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS && \
    #wget ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig && \
    #gpg --batch --verify consul_${CONSUL_VERSION}_SHA256SUMS.sig consul_${CONSUL_VERSION}_SHA256SUMS && \
    #grep consul_${CONSUL_VERSION}_linux_${consulArch}.zip consul_${CONSUL_VERSION}_SHA256SUMS | sha256sum -c && \
    mkdir -p $PKG_ROOT/usr/local/bin && \
    unzip -d $PKG_ROOT/usr/local/bin consul_${CONSUL_VERSION}_linux_${consulArch}.zip && \
    install -m644 -D /consul.service $PKG_ROOT/usr/lib/systemd/system/consul.service &&\
    # tiny smoke test to ensure the binary we downloaded runs
    $PKG_ROOT/usr/local/bin/consul version

RUN \
    fpm -f --verbose \
    -n consul \ 
    -s dir \
    --iteration 1.el7 \
    -v ${CONSUL_VERSION} \
    -t rpm \
    -m hashicorp \
    --vendor hashicorp \
    -a native \
    -p /root/ \
    -C $PKG_ROOT \
    --description 'Consul is a service mesh solution' \
    #--conflicts 'nginx,tegine.openresty,kong' \
    --url 'https://www.consul.io/' \
    --before-install /before-install.sh \
    #--after-install /after-install.sh \
    --after-remove /after-remove.sh \
    --config-files /etc/consul.d/

FROM slpcat/centos:7
COPY --from=builder /root/consul-1.7.2-1.el7.x86_64.rpm /root
RUN yum install -y /root/consul-1.7.2-1.el7.x86_64.rpm /root

# Expose the consul data directory as a volume since there's mutable state in there.
VOLUME /var/lib/consul

# Server RPC is used for communication between Consul clients and servers for internal
# request forwarding.
EXPOSE 8300

# Serf LAN and WAN (WAN is used only by Consul servers) are used for gossip between
# Consul agents. LAN is within the datacenter and WAN is between just the Consul

# servers in all datacenters.
EXPOSE 8301 8301/udp 8302 8302/udp

# HTTP and DNS (both TCP and UDP) are the primary interfaces that applications
# use to interact with Consul.
EXPOSE 8500 8600 8600/udp

# Consul doesn't need root privileges so we run it as the consul user from the
# entry point script. The entry point script also uses dumb-init as the top-level
# process to reap any zombie processes created by Consul sub-processes.

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# By default you'll get an insecure single-node development server that stores
# everything in RAM, exposes a web UI and HTTP endpoints, and bootstraps itself.
# Don't use this configuration for production.
CMD ["agent", "-dev", "-client", "0.0.0.0"]
