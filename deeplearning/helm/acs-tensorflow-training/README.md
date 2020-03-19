# Distributed TensorFlow Training

TensorFlow is an open-source software library for training machine learning models.

For more information,
[visit Distributed TensorFlow](https://www.tensorflow.org/deploy/distributed).

## Prerequisites

- A Kubernetes cluster of Alibaba Cloud Container Service v1.9+ has been created. Refer to [guidance document](https://www.alibabacloud.com/help/doc-detail/53752.html).
- Because TensorFlow Training needs input and output in pesistent storage, you have to use NAS, OSS or other persistent volume. Here is a sample to do the distributed training in AliCloud NAS Storage.

## Prepare Data Directory

You can train an mnist model using the instructions from the [TensorFlow documentation](https://www.tensorflow.org/tutorials/layers).  

* Create `/data` directory in the NFS server side

```
mkdir /nfs
mount -t nfs -o vers=4.0 3fcc94a4ec-rms76.cn-shanghai.nas.aliyuncs.com:/ /nfs
mkdir -p /nfs/data
umount /nfs
```


## Create Persistent Volume

Creating Persistent Volume with configuration like this, for more details, please refer [Alibaba Cloud Volume](https://www.alibabacloud.com/help/doc-detail/63953.htm)

```
--- 
apiVersion: v1
kind: PersistentVolume
metadata: 
  labels: 
    train: mnist
  name: pv-nas
spec:
  persistentVolumeReclaimPolicy: Retain
  accessModes: 
    - ReadWriteMany
  capacity: 
    storage: 5Gi
  flexVolume: 
    driver: alicloud/nas
    options: 
      mode: "755"
      path: /data
      server: 3fcc94a4ec-rms76.cn-shanghai.nas.aliyuncs.com
      vers: "4.0"
```

## Define values.yaml

* To deploy with distributed TensorFlow with GPU, you can create `values.yaml` like

```
---
worker:
  number: 2
  gpuCount: 1
  image: registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tf-mnist-k8s:gpu
  imagePullPolicy: IfNotPresent
  # if you'd like to choose the cusomtized docker image,
  #image: ""

ps:
  number: 2
  image: registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tf-mnist-k8s:cpu
  imagePullPolicy: IfNotPresent
   # if you'd like to choose the cusomtized docker image,
  #image: ""

tensorboard:
  image: registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tensorboard:1.1.0

hyperparams:
  epochs: 100
  batchsize: 20
  learningrate: 0.001

persistence:
  mountPath: /data
  pvc:
    matchLabels:
      train: mnist
    storage: 5Gi
```

* To deploy distributed TensorFlow without GPU, you can create `values.yaml` like 

```
---
worker:
  number: 2
  # if you'd like to choose the cusomtized docker image
  image: registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tf-mnist-k8s:cpu
  imagePullPolicy: IfNotPresent

ps:
  number: 2
  # if you'd like to choose the cusomtized docker image
  image: registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tf-mnist-k8s:cpu
  imagePullPolicy: IfNotPresent

tensorboard:
  image: registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tensorboard:1.1.0

hyperparams:
  epochs: 100
  batchsize: 20
  learningrate: 0.001

persistence:
  mountPath: /data
  pvc:
    matchLabels:
      train: mnist
    storage: 5Gi
```

## Installing the Chart

To install the chart with the release name `mnist`:

```bash
$ helm install --values values.yaml --name mnist incubator/acs-tensorflow-training
```

## Uninstalling the Chart

To uninstall/delete the `mnist` deployment:

```bash
$ helm delete mnist
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following tables lists the configurable parameters of the Service Tensorflow training
chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `worker.image` | TensorFlow training image | `registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tf-mnist-k8s:gpu` |
| `worker.gpuCount`| The gpu resource for worker, if it's 0, means no gpu  | `1` |
| `worker.imagePullPolicy` | `imagePullPolicy` for the service mnist | `IfNotPresent` |
| `worker.port` | Tensorflow worker's port | `9000` |
| `ps.image` | TensorFlow training image | `registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tf-mnist-k8s:cpu` |
| `ps.gpuCount`| The gpu resource for ps, if it's 0, means no gpu  | `1` |
| `ps.imagePullPolicy` | `imagePullPolicy` for the service mnist | `IfNotPresent` |
| `ps.port` | Tensorflow parameter server's port | `8000` |
| `tensorboard.serviceType` | The service type of tensorboard which supports NodePort, LoadBalancer | `LoadBalancer` |
| `tensorboard.image` | The service type of tensorboard which supports NodePort, LoadBalancer | `LoadBalancer` |
| `mountPath`| the mount path inside the containers, which is used for keeping training logs, checkpoints, model into the persistent storage| `/training/model/mnist` |
| `persistence.pvc.storage`| the storage size to request | `5Gi` |
| `persistence.pvc.matchLabels`| the selector for pv | `{}` |
| `hyperparams.epochs`| the iterations over all of the training data | `100` |
| `hyperparams.batchsize`| the batch size | `20` |
| `hyperparams.learningrate`| the learning rate | `0.001` |



