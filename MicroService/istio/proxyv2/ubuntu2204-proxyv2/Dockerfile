FROM  istio/proxyv2:1.12.2

RUN \
    sed -i s/focal/jammy/g  /etc/apt/sources.list && \
    apt-get update &&   \
    DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes --option=Dpkg::Options::=--force-confold dist-upgrade && \
    apt-get clean

# Default to the xtables backend of iptables.
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy
RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
