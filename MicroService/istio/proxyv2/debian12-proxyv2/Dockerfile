FROM  istio/proxyv2:1.12.2 as tools

FROM debian:12-slim

ENV ISTIO_META_ISTIO_PROXY_SHA=istio-proxy:e6f45abcf874983fbff384459d70b28c072f68b5
ENV ISTIO_META_ISTIO_VERSION=1.12.2

RUN apt-get update &&   \
    apt-get upgrade -y && \
    apt-get install -y   ca-certificates   curl   iptables   iproute2   \
    iputils-ping   knot-dnsutils   procps netcat-openbsd  tcpdump   conntrack   bsdmainutils   net-tools   lsof   sudo  && \
    update-ca-certificates && \
    apt-get clean

# Default to the xtables backend of iptables.
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy
RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

RUN useradd -m --uid 1337 istio-proxy && \
    echo "istio-proxy ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY --from=tools  /var/lib/istio/envoy /var/lib/istio/envoy
COPY --from=tools /usr/local/bin/envoy  /usr/local/bin/envoy
COPY --from=tools /usr/local/bin/pilot-agent /usr/local/bin/pilot-agent
COPY --from=tools /etc/istio/extensions /etc/istio/extensions

ENTRYPOINT ["/usr/local/bin/pilot-agent"]
