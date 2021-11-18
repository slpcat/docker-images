#upstream https://github.com/kubernetes-incubator/external-storage/blob/master/ceph/rbd/Dockerfile
FROM centos:7

ENV CEPH_VERSION "nautilus"
RUN rpm -Uvh https://download.ceph.com/rpm-$CEPH_VERSION/el7/noarch/ceph-release-1-1.el7.noarch.rpm && \
  yum install -y epel-release && \
  yum install -y --nogpgcheck ceph-common && \
  yum clean all

COPY --from=slpcat/rbd-provisioner:v2.1.1-k8s1.11 /usr/local/bin/rbd-provisioner /usr/local/bin/rbd-provisioner
ENTRYPOINT ["/usr/local/bin/rbd-provisioner"]
