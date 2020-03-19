# upstream https://github.com/container-images/systemtap
FROM registry.fedoraproject.org/fedora:26

MAINTAINER 若虚 <slpcat@qq.com>

ENV NAME=systemtap VERSION=0 RELEASE=1 ARCH=x86_64

LABEL com.redhat.component="$NAME" \
      name="$FGC/$NAME" \
      version="$VERSION" \
      release="$RELEASE.$DISTTAG" \
      architecture="$ARCH" \
      run="docker run --cap-add SYS_MODULE -v /sys/kernel/debug:/sys/kernel/debug -v /usr/src/kernels:/usr/src/kernels -v /usr/lib/modules/:/usr/lib/modules/ -v /usr/lib/debug:/usr/lib/debug -t -i --name NAME IMAGE" \
      summary="programmable system-wide instrumentation system"

# set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN  \
    dnf update -y && \
    dnf install -y systemtap-testsuite systemtap systemtap-client && \
    dnf clean all

COPY ./root /

CMD ["/bin/bash"]
