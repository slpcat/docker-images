#Currently this Dockerfile is supported on building on Ubuntu only.
FROM slpcat/ubuntu:22.04

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
	perl \
	tcsh tcl tk pciutils make lsof \
	lsb-release \
	libnuma1 \
	ethtool iproute2 net-tools \
	openssh-server \
	wget git \
	pkg-config bison dpatch \
	kmod linux-headers-generic libnl-route-3-200 \
	swig libelf1 automake libglib2.0-0 \
	autoconf graphviz chrpath flex libnl-3-200 m4 \
	debhelper autotools-dev gfortran libltdl-dev iperf
RUN apt install -y ca-certificates

WORKDIR /tmp/

ENV MOFED_VER 23.10-1.1.9.0
ENV OS_VER ubuntu22.04
ENV PLATFORM x86_64

RUN wget --quiet http://content.mellanox.com/ofed/MLNX_OFED-${MOFED_VER}/MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}.tgz && \
        tar -xvf MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}.tgz && \
        MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}/mlnxofedinstall --user-space-only --without-fw-update --all --force
