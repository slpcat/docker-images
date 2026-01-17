#upstream: https://github.com/dockage/alpine-runit/blob/main/Dockerfile
FROM dockage/alpine:3.7

MAINTAINER Mohammad Abdoli Rad <m.abdolirad@gmail.com>

LABEL org.label-schema.name="alpine-runit" \
        org.label-schema.vendor="Dockage" \
        org.label-schema.description="Docker image uses runit as a process supervision on Alpine Linux" \
        org.label-schema.vcs-url="https://github.com/dockage/alpine-runit" \
        org.label-schema.version="3.7" \
        org.label-schema.license="MIT"

STOPSIGNAL SIGCONT

ENV SERVICE_AVAILABLE_DIR=/etc/sv \
    SERVICE_ENABLED_DIR=/service

ENV SVDIR=${SERVICE_ENABLED_DIR} \
    SVWAIT=7

ADD https://rawgit.com/dockage/runit-scripts/master/scripts/installer /opt/

RUN apk update \
    && apk --no-cache add runit \
    && mkdir -p ${SERVICE_AVAILABLE_DIR} ${SERVICE_ENABLED_DIR} \
    && chmod +x /opt/installer \
    && sync \
    && /opt/installer \
    && rm -rf /var/cache/apk/* /opt/installer

CMD ["/sbin/runit-init"]
