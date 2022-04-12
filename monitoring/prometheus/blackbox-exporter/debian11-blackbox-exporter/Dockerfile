FROM slpcat/debian:bullseye
MAINTAINER 若虚 <slpcat@qq.com>

RUN \
    apt-get update -y && \
    apt-get install -y inetutils-ping libcap2-bin

COPY --from=quay.io/prometheus/blackbox-exporter:v0.20.0 /bin/blackbox_exporter  /bin/blackbox_exporter
COPY blackbox.yml       /etc/blackbox_exporter/config.yml

RUN setcap cap_net_admin,cap_net_raw+ep /bin/blackbox_exporter

USER nobody
EXPOSE      9115
ENTRYPOINT  [ "/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
