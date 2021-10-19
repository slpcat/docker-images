#upstream https://github.com/kubernetes-incubator/external-storage/blob/master/ceph/rbd/Dockerfile
FROM slpcat/golang-gvm AS builder
MAINTAINER 若虚 <slpcat@qq.com>

#get source code
RUN git clone https://github.com/kubernetes-incubator/external-storage.git \
    && cd external-storage \
    && git checkout rbd-provisioner-v2.1.1-k8s1.11
COPY go_build.sh /go_build.sh
RUN /go_build.sh

#upstream https://github.com/kubernetes-incubator/external-storage/blob/master/ceph/rbd/Dockerfile
FROM centos:7

ENV CEPH_VERSION "nautilus"
RUN rpm -Uvh https://download.ceph.com/rpm-$CEPH_VERSION/el7/noarch/ceph-release-1-1.el7.noarch.rpm && \
  yum install -y epel-release && \
  yum install -y --nogpgcheck ceph-common && \
  yum clean all

COPY --from=builder /rbd-provisioner /usr/local/bin/rbd-provisioner
ENTRYPOINT ["/usr/local/bin/rbd-provisioner"]
