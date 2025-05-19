FROM alpine:3.21
LABEL maintainer="dskadra@gmail.com"

RUN apk add --update --no-cache qemu-guest-agent

ENTRYPOINT [ "/usr/bin/qemu-ga" ]
CMD ["-m", "virtio-serial", "-p", "/dev/virtio-ports/org.qemu.guest_agent.0"]