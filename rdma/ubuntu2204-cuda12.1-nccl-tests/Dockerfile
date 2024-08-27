FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04 as base
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm-256color" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y vim-tiny net-tools iproute2 procps curl wget telnet less


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

#install nvidia-fabricmanager

#install openmpi
RUN apt-get install -yopenmpi-bin openmpi-common libopenmpi-dev

#install nccl

RUN \
    cd /root && \
    git clone https://github.com/NVIDIA/nccl-tests.git && \
    cd ./nccl-tests && \
    make  MPI=1 MPI_HOME=/usr/mpi/gcc/openmpi-4.1.2a1 -j 8
