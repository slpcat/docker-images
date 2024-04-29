FROM slpcat/ubuntu:22.04
MAINTAINER 若虚 <slpcat@qq.com>

ENV PATH /usr/local/bin:$PATH

RUN \
    apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y vim-tiny net-tools iproute2 procps curl wget telnet less

RUN \
    apt-get update -y && \
    apt-get install -y libexpat1 libglib2.0-dev tcl tk google-perftools git git-lfs pkg-config gcc g++ \
        build-essential software-properties-common \
        netperf htop libtool iproute2 iputils-ping ncat nmap tcpdump socat \
        cmake pciutils ethtool libnuma-dev numactl numatop lsof libpcap-dev libfdt-dev libarchive-dev \
        libbsd-dev libjansson-dev libelf-dev libcrypto++-dev libbpf-dev doxygen python3-pyelftools python3-sphinx \
        openssl libssl-dev libisal-dev meson

# mlx5 ofed
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

WORKDIR /usr/src/

ENV MOFED_VER 5.8-4.1.5.0
ENV OS_VER ubuntu22.04
ENV PLATFORM x86_64

RUN wget --quiet http://content.mellanox.com/ofed/MLNX_OFED-${MOFED_VER}/MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}.tgz && \
        tar -xvf MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}.tgz && \
        MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}/mlnxofedinstall --upstream-libs --dpdk --user-space-only --without-fw-update --all --force

#https://github.com/intel/intel-ipsec-mb


ARG DPDK_VERSION=22.11
#DPDK编译依赖
RUN \
    cd /usr/src && \
    wget https://fast.dpdk.org/rel/dpdk-$DPDK_VERSION.tar.xz && \
    tar xf dpdk-$DPDK_VERSION.tar.xz && \
    cd dpdk-$DPDK_VERSION && \
    meson  build && \
    cd build && \
    ninja && \
    ninja install && \
    rm -rf dpdk* MLNX_OFED* 
