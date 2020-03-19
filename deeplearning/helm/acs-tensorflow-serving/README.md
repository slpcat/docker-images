# TensorFlow Serving

SensorFlow Serving is an open-source software library for serving machine learning models.

For more information,
[visit the project on github](https://github.com/tensorflow/serving).

## Prerequisites

- A Kubernetes cluster of Alibaba Cloud Container Service v1.9+ has been created. Refer to [guidance document](https://www.alibabacloud.com/help/doc-detail/53752.html).
- Because TensorFlow Serving needs model in persistent storage, you have to put your servable model in NAS, OSS or other storages, then create Persistent Volume. Here is a sample for you to put model in AliCloud NAS Storage.

## Putting a Model in AliCloud NAS Storage

You can train an mnist model using the instructions from the [TensorFlow documentation](https://www.tensorflow.org/tutorials/layers).  

* Choose an ECS to put the Model, create `/serving` directory in the NFS server side

```
mkdir /nfs
mount -t nfs -o vers=4.0 3fcc94a4ec-rms76.cn-shanghai.nas.aliyuncs.com:/ /nfs
mkdir -p /nfs/serving
umount /nfs
```

* Put the mnist model into NAS

```
mkdir /serving
mount -t nfs -o vers=4.0 3fcc94a4ec-rms76.cn-shanghai.nas.aliyuncs.com:/serving /serving
mkdir -p /serving/model
cd /serving/model
curl -O http://tensorflow-samples.oss-cn-shenzhen.aliyuncs.com/exports/mnist-export.tar.gz
tar -xzvf mnist-export.tar.gz
rm -rf mnist-export.tar.gz
cd /
```

* You will see that the contents of the model are stored in the  directory. This is the first version of the model that we will serve.

```
tree /serving/model/mnist
/serving/model/mnist
└── 1
    ├── saved_model.pb
    └── variables
        ├── variables.data-00000-of-00001
        └── variables.index

umount /serving
```

## Create Persistent Volume

Creating Persistent Volume with configuration like this, for more details, please refer [Alibaba Cloud Volume](https://www.alibabacloud.com/help/doc-detail/63953.htm)

```
--- 
apiVersion: v1
kind: PersistentVolume
metadata: 
  labels: 
    model: mnist
  name: pv-nas
spec:
  persistentVolumeReclaimPolicy: Recycle
  accessModes: 
    - ReadWriteMany
  capacity: 
    storage: 5Gi
  flexVolume: 
    driver: alicloud/nas
    options: 
      mode: "755"
      path: /serving/model/mnist
      server: 3fcc94a4ec-rms76.cn-shanghai.nas.aliyuncs.com
      vers: "4.0"
```

## Prepare values.yaml

* To deploy with GPU, you can create `values.yaml` like

```
---
command: 
  - /usr/bin/tensorflow_model_server
args: 
  - "--port=9090"
  - "--model_name=mnist"
  - "--model_base_path=/serving/model/mnist"
image: "registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tensorflow-serving:1.4.0-devel"
persistence: 
  mountPath: /serving/model/mnist
  pvc: 
    matchLabels: 
      model: mnist
    storage: 5Gi
```

* To deploy without GPU, you can create `values.yaml` like 

```
---
command: 
  - /usr/bin/tensorflow_model_server
args: 
  - "--port=9090"
  - "--model_name=mnist"
  - "--model_base_path=/serving/model/mnist"
image: "registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tensorflow-serving:1.4.0-devel"
persistence: 
  mountPath: /serving/model/mnist
  pvc: 
    matchLabels: 
      model: mnist
    storage: 5Gi
```

## Installing the Chart

To install the chart with the release name `mnist`:

```bash
$ helm install --values values.yaml --name mnist incubator/acs-tensorflow-serving
```

## Uninstalling the Chart

To uninstall/delete the `mnist` deployment:

```bash
$ helm delete mnist
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following tables lists the configurable parameters of the Service Tensorflow Serving
chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image` | TensorFlow Serving image | `registry.cn-hangzhou.aliyuncs.com/tensorflow-samples/tensorflow-serving:1.4.0-devel-gpu` |
| `imagePullPolicy` | `imagePullPolicy` for the service mnist | `IfNotPresent` |
| `port` | Tensorflow server port | `9090` |
| `serviceType` | The service type which supports NodePort, LoadBalancer | `LoadBalancer` |
|`replicas`| K8S deployment replicas | `1` |
|`gpuCount`| The gpu resource to claim, if it's 0, means no gpu  | `1` |
|`command`|  The command to run | `["/usr/bin/tensorflow_model_server"]`|
|`args`| The argument for the command | `[ "--port=9090", "--model_name=mnist", "--model_base_path=/serving/model/mnist"] ` |
|`mountPath`| the mount path inside the container | `/serving/model/mnist` |
|`persistence.pvc.storage`| the storage size to request | `5Gi` |
|`persistence.pvc.matchLabels`| the selector for pv | `{}` |



