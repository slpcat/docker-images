#!/bin/bash
source /root/.gvm/scripts/gvm
gvm use go1.11 --default
export CGO_ENABLED=0
export GOOS=linux
go get github.com/golang/glog
go get github.com/kubernetes-incubator/external-storage/ceph/rbd/pkg/provision
go get github.com/kubernetes-incubator/external-storage/lib/controller
go get k8s.io/apimachinery/pkg/util/wait
go get k8s.io/client-go/kubernetes
go get k8s.io/client-go/rest
go get k8s.io/client-go/tools/clientcmd
cd /external-storage/ceph/rbd
go build -a -ldflags '-extldflags "-static"' -o /rbd-provisioner ./cmd/rbd-provisioner
#go build -ldflags="-s -w" -o hello hello.go
