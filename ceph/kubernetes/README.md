Ceph on Kubernetes

ceph作为Kubernetes持久存储服务，以特权pod形式运行,osd能够访问宿主机硬盘，提供rbd存储类，支持自动创建持久卷供其他pod使用,实现超融合基础设施(Hyper converged infrastructure)

使用限制与要求

kubernetes 宿主机osd硬盘至少1TB,未分区裸盘，至少3个节点用于ceph存储，宿主机支持多个osd硬盘
kubernetes 宿主机节点内核版本 >= 4.15
kubernetes 宿主机节点ceph版本支持mimic和luminous
注：本文所用yaml涉及容器内核参数调优，需要内核版本4.15,低版本内核需要注释或者删除sysctl相关条目。
ceph public和cluster networks必须相同，并且是kubernetes的集群宿主机网络.If the storage class user id is not admin, you will have to manually create the user in your Ceph cluster and create its secret in Kubernetes
ceph-mgr can only run with 1 replica
rgw对象存储支持集群内部和外部同时访问

生产环境安装过程

安装前规划与准备
奇数个宿主机节点作为mon，通常3个，直接使用宿主机目录作为持久存储
osd数据盘使用宿主机未分区裸盘,本文以/dev/vdb为例
所有宿主机节点安装ceph客户端 apt-get install ceph-common 或者yum install ceph-common
所有宿主机节点dns解析使用集群dns服务器
/etc/resolv.conf
domain <EXISTING_DOMAIN>
search <EXISTING_DOMAIN>

#Your kubernetes cluster ip domain
search ceph.svc.cluster.local svc.cluster.local cluster.local

nameserver 10.233.0.3     #The cluster IP of skyDNS
nameserver <EXISTING_RESOLVER_IP>

客户端（控制台）要求
In addition to kubectl, jinja2 or sigil is required for template handling and must be installed in your system PATH. Instructions can be found here for jinja2 https://github.com/mattrobenolt/jinja2-cli or here for sigil https://github.com/gliderlabs/sigil.

覆盖默认的网络设置,本方案使用宿主机的网络
export osd_cluster_network=172.17.0.0/16
export osd_public_network=172.17.0.0/16

生成keys和ceph配置

cd generator
./generate_secrets.sh all `./generate_secrets.sh fsid`

ceph.conf 生产环境需要做参数调整，修改完毕执行以下命令
kubectl create namespace ceph

kubectl create secret generic ceph-conf-combined --from-file=ceph.conf --from-file=ceph.client.admin.keyring --from-file=ceph.mon.keyring --namespace=ceph
kubectl create secret generic ceph-bootstrap-rgw-keyring --from-file=ceph.keyring=ceph.rgw.keyring --namespace=ceph
kubectl create secret generic ceph-bootstrap-mds-keyring --from-file=ceph.keyring=ceph.mds.keyring --namespace=ceph
kubectl create secret generic ceph-bootstrap-osd-keyring --from-file=ceph.keyring=ceph.osd.keyring --namespace=ceph
kubectl create secret generic ceph-bootstrap-rbd-keyring --from-file=ceph.keyring=ceph.rbd.keyring --namespace=ceph
kubectl create secret generic ceph-client-key --from-file=ceph-client-key --namespace=ceph

cd ..
注：如果调整ceph.conf配置，需要重新生成secret

生产环境部署ceph组件
生成RBAC授权
kubectl create -f ceph-rbac.yaml

给存储节点打上标签(必须)
所有的存储节点
kubectl label node <nodename> node-type=storage
或者所有节点都打上标签
kubectl label nodes node-type=storage --all
mon节点标签
kubectl label node <nodename> ceph-mon=enabled

ceph mds 启用cephfs 可选
kubectl create -f ceph-mds-v1-dp.yaml

ceph mgr
kubectl create -f ceph-mgr-v1-dp.yaml
kubectl create -f ceph-mgr-dashboard-v1-svc.yam
kubectl create -f ceph-mgr-prometheus-v1-svc.yaml

ceph mon
2n+1台 生产3台或者5台，宿主机节点需要标签  ceph-mon: enabled

打开文件 ceph-mon-v1-ds.yaml
- name: CEPH_PUBLIC_NETWORK
              value: 172.17.0.0/16
修改为相应的宿主机网段

kubectl create -f ceph-mon-v1-svc.yaml
kubectl create -f ceph-mon-v1-ds.yaml
kubectl create -f ceph-mon-check-v1-dp.yam

kubectl exec -it ceph-mon-XXXX -n ceph bash

ceps -s 检查确认一切正常再进行下一步

ceph osd持久存储
每个盘对应一个pod,本示例使用/dev/vdb,如果有多个磁盘修改ceph-osd-prepare-v1-ds.yaml和ceph-osd-activate-v1-ds.yaml然后依次创建
先初始化磁盘

kubectl create -f ceph-osd-prepare-v1-ds.yaml --namespace=ceph
初始化成功后删除pod
kubectl delete -f ceph-osd-prepare-v1-ds.yaml --namespace=ceph

初始化完毕，激活磁盘
kubectl create -f ceph-osd-activate-v1-ds.yaml --namespace=ceph

ceph rgw对象存储 可选
kubectl create -f ceph-rgw-v1-dp.yaml
kubectl create -f ceph-rgw-v1-svc.yaml

kubernetes使用外部持久卷
https://github.com/kubernetes-incubator/external-storage/tree/master/ceph/rbd/deploy/rbac
进入mon pod
kubectl exec -it ceph-mon-XXXX bash
创建存储池
ceph osd pool create kube 256
创建keyring
ceph auth get-or-create client.kube mon 'allow r' osd \
  'allow class-read object_prefix rbd_children, allow rwx pool=kube' \
  -o ceph.client.kube.keyring
根据生成的keyring创建secret
kubectl --namespace=ceph create secret generic ceph-rbd-kube \
  --from-literal="key=$(grep key ceph.client.kube.keyring  | awk '{ print $3 }')" \
  --type=kubernetes.io/rbd

创建RBD provisioner 使用namespace=ceph
创建rbac授权
kubectl create -f rbd-provisioner/clusterrolebinding.yaml
kubectl create -f rbd-provisioner/clusterrole.yaml
kubectl create -f rbd-provisioner/rolebinding.yaml
kubectl create -f rbd-provisioner/role.yaml
kubectl create -f rbd-provisioner/serviceaccount.yaml
创建RBD provisioner pod
kubectl create -f rbd-provisioner/deployment.yaml
创建RBD存储类，并且设置为默认存储类
kubectl create secret generic ceph-secret-admin --from-file=generator/ceph-client-key --type=kubernetes.io/rbd --namespace=ceph
kubectl create -f rbd-provisioner/storage-class.yaml

至此, 自动创建rbd卷提供pvc持久存储全部完成

以下为功能验证阶段
POD作为使用者,只需创建pvc获取相应容量的存储，然后挂载即可自动获取存储资源
创建pvc 示例
kubectl create -f https://raw.githubusercontent.com/kubernetes/examples/master/staging/persistent-volume-provisioning/claim1.json

POD里面挂载pvc卷,通常是有状态副本集statefulset.示例

rbd-pvc-pod.yaml

生产环境推荐使用有状态副本集statefulset自动创建pvc
  volumeClaimTemplates:
  - metadata:
      name: datadir
    spec:
      accessModes:
      - ReadWriteOnce
      #ceph rbd storageclass
      storageClassName: rbd
      resources:
        requests:
          storage: 10Gi

POD里面挂载CephFS,通常是有状态副本集statefulset.示例
must add the admin client key

$ kubectl get all --namespace=ceph
NAME                   DESIRED      CURRENT       AGE
ceph-mds               1            1             24s
ceph-mon-check         1            1             24s
NAME                   CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
ceph-mon               None         <none>        6789/TCP   24s
NAME                   READY        STATUS        RESTARTS   AGE
ceph-mds-6kz0n         0/1          Pending       0          24s
ceph-mon-check-deek9   1/1          Running       0          24s

$ kubectl get pods --namespace=ceph
NAME                   READY     STATUS    RESTARTS   AGE
ceph-mds-6kz0n         1/1       Running   0          4m
ceph-mon-8wxmd         1/1       Running   2          2m
ceph-mon-c8pd0         1/1       Running   1          2m
ceph-mon-cbno2         1/1       Running   1          2m
ceph-mon-check-deek9   1/1       Running   0          4m
ceph-mon-f9yvj         1/1       Running   1          2m
ceph-osd-3zljh         1/1       Running   2          2m
ceph-osd-d44er         1/1       Running   2          2m
ceph-osd-ieio7         1/1       Running   2          2m
ceph-osd-j1gyd         1/1       Running   2          2m

$ kubectl describe pvc claim1
Name:           claim1
Namespace:      default
StorageClass:
Status:         Bound
Volume:         pvc-a9247186-6e59-11e7-b7b6-00259003b6e8
Labels:         <none>
Capacity:       3Gi
Access Modes:   RWO
Events:
  FirstSeen     LastSeen        Count   From                                                                                    SubObjectPath   Type            Reason                  Message
  ---------     --------        -----   ----                                                                                    -------------   --------        ------                  -------
  6m            6m              2       {persistentvolume-controller }                                                                 Normal           ExternalProvisioning    cannot find provisioner "ceph.com/rbd", expecting that a volume for the claim is provisioned either manually or via external software
  6m            6m              1       {ceph.com/rbd rbd-provisioner-217120805-9dc84 57e293c8-6e59-11e7-a834-ca4351e8550d }           Normal           Provisioning            External provisioner is provisioning volume for claim "default/claim1"
  6m            6m              1       {ceph.com/rbd rbd-provisioner-217120805-9dc84 57e293c8-6e59-11e7-a834-ca4351e8550d }           Normal           ProvisioningSucceeded   Successfully provisioned volume pvc-a9247186-6e59-11e7-b7b6-00259003b6e8

Mounting CephFS in a pod

First you must add the admin client key to your current namespace (or the namespace of your pod).

kubectl create secret generic ceph-client-key --type="kubernetes.io/rbd" --from-file=./generator/ceph-client-key
Now, if skyDNS is set as a resolver for your host nodes then execute the below command as is. Otherwise modify the ceph-mon.ceph host to match the IP address of one of your ceph-mon pods.

kubectl create -f ceph-cephfs-test.yaml --namespace=ceph
You should be able to see the filesystem mounted now

kubectl exec -it --namespace=ceph ceph-cephfs-test df
Mounting a Ceph RBD in a pod

First we have to create an RBD volume.

# This gets a random MON pod.
export PODNAME=`kubectl get pods --selector="app=ceph,daemon=mon" --output=template --template="{{with index .items 0}}{{.metadata.name}}{{end}}" --namespace=ceph`

kubectl exec -it $PODNAME --namespace=ceph -- rbd create ceph-rbd-test --size 20G

kubectl exec -it $PODNAME --namespace=ceph -- rbd info ceph-rbd-test
The same caveats apply for RBDs as Ceph FS volumes. Edit the pod accordingly. Once you're set:

kubectl create -f ceph-rbd-test.yaml --namespace=ceph
And again you should see your mount, but with 20 gigs free

kubectl exec -it --namespace=ceph ceph-rbd-test -- df -h

cephfs动态卷使用
创建cephfs存储类
kubectl create -f cephfs-provisioner
POD作为使用者,只需创建pvc获取相应容量的存储，然后挂载即可自动获取存储资源
创建pvc 示例
kubectl create -f cephfs-pv-claim.yaml

生产环境POD里面挂载pvc卷,通常是有状态副本集statefulset，cephfs支持多个POD同时写入同一文件系统。示例
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes:
      - ReadWriteMany
      #cephfs storageclass
      storageClassName: cephfs
      resources:
        requests:
          storage: 10Gi

ceph开启内置dashboard
http://docs.ceph.com/docs/master/mgr/dashboard/
开启dashboard 功能
ceph mgr module enable dashboard
创建证书
ceph dashboard create-self-signed-cert
创建 web 登录用户密码
ceph dashboard set-login-credentials user-name password
查看服务访问方式
ceph mgr services

开启Prometheus exporter
ceph mgr module enable prometheus

ceph存储节点扩容操作
新的节点打上临时标签
kubectl label node <nodename> ceph-new=true
修改文件ceph-osd-prepare-v1-ds.yaml
      nodeSelector:
        ceph-new: true

kubectl create -f ceph-osd-prepare-v1-ds.yaml --namespace=ceph
等待prepare completed之后
然后node删掉标签ceph-new=true 添加标签node-type=storage
等待自动创建osd-actviate最后osd加入ceph集群

Durable Storage
By default emptyDir is used for everything. If you have durable storage on your nodes, replace the emptyDirs with a hostPath to that storage.


警告: rook-ceph足够稳定后，可以考虑使用rook https://rook.io/docs/rook/v1.2/ceph-storage.html

参考：
1.https://github.com/ceph/ceph-container/tree/master/examples/kubernetes
2.http://docs.ceph.com/docs/master/start/kube-helm/
3.https://github.com/kubernetes-incubator/external-storage/tree/master/ceph/rbd
4.http://tracker.ceph.com/projects/ceph/wiki/Tuning_for_All_Flash_Deployments
5.http://docs.ceph.com/docs/master/rados/configuration/
