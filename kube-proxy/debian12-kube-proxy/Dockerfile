FROM slpcat/cce-kube-proxy:v1.20.8 as tools

FROM debian:12-slim

RUN apt-get update && apt-get install -y \
    ipset \
    iptables \
    iproute2 \
    iputils-arping \
    iputils-ping \
    iputils-tracepath \
    # Need arp
    net-tools \
    conntrack \
    runit \
    # Need kmod to ensure ip6tables-save works correctly
    kmod \
    # Need netbase in order for ipset to work correctly
    # See https://github.com/kubernetes/kubernetes/issues/68703
    netbase \
    # Also needed (provides utilities for browsing procfs like ps)
    procps \
    ca-certificates \
    # Felix FV tests require these
    wget \
    ethtool \
    tcpdump \
    hping3 \
    ebtables

# Default to the xtables backend of iptables.
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy
RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

COPY --from=tools /usr/local/bin/kube-proxy /usr/local/bin/kube-proxy
#/usr/sbin/iptables-wrapper

