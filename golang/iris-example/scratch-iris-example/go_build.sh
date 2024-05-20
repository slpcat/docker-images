#!/bin/bash
source /root/.gvm/scripts/gvm
gvm use go1.11 --default
export CGO_ENABLED=0
go get github.com/kataras/iris
go build -ldflags="-s -w" -o hello hello.go
