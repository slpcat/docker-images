FROM slpcat/debian:bullseye
COPY --from=slpcat/kubernetes-event-exporter:v0.11 /kubernetes-event-exporter /kubernetes-event-exporter

ENTRYPOINT ["/kubernetes-event-exporter"]
