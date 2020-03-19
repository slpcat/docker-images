DOCKER ?= docker

.NOTPARALLEL:
.PHONY: all

all: cpu gpu

cpu:
	$(DOCKER) build -f Dockerfile.cpu -t registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tf-mnist-k8s:cpu .

gpu: 
	$(DOCKER) build -f Dockerfile -t registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tf-mnist-k8s:gpu .