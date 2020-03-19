https://docs.openebs.io/docs/next/installation.html

https://docs.openebs.io/docs/next/prerequisites.html
iSCSI Root
当直接通过一个ISCSI磁盘访问根分区的时候,iSCSI计时器应该被设置,以便iSCSI层有足够的时间重建会话/路径。此外,命令不应过快在SCSI层重排。这个是对立的，当实施多路径的时候应该被完成。
首先,NOP-Outs应该被禁用。你可以通过NOP-Out间隔和超时设置为零。设置这个打开/etc/iscsi/iscsid.conf编辑修改参数如下:
node.conn[0].timeo.noop_out_interval = 0
node.conn[0].timeo.noop_out_timeout = 0
以上修改之后,replacement_timeout应该设置为高的数字。这将指示系统等很长时间让会话/路径重建自己的连接。调整replacement_timeout,打开/etc/iscsi/iscsid.conf编辑以下行:
node.session.timeo.replacement_timeout = 替换的时间（默认是120，我改为2000）
在配置/etc/iscsi/iscsid.config之后,你必须执重新读取配置命令，去实时生效。让系统使用新配置的数值。

为一个单独的会话设置超时：
你还可以为特定的会话设置超时,让他们非持久性(而不是使用/ etc / iscsi / iscsid.conf的配置)。为此,运行以下命令(替换相应的变量):
# iscsiadm -m node -T target_name -p target_IP:port -o update -n node.session.timeo.replacement_timeout -v $timeout_value

service tgtd restart
service iscsi restart
service netfs restart
service iscsid restart

1.宿主机安装open-iscsi
Debian/Ubuntu
apt-get install open-iscsi
systemctl enable open-iscsi
systemctl start open-iscsi
Centos
yum -y install iscsi-initiator-utils
systemctl enable iscsid
systemctl start iscsid

2.使用Operator安装运行OpenEBS
宿主机数据存储目录: /var/openebs
宿主机标签
# kubectl label node <node-name> "openebs.io/nodegroup"="storage-node"
#nodeSelector:
#  "openebs.io/nodegroup": "storage-node"

kubectl label nodes <node-name> node=openebs
nodeSelector:
  node: openebs

kubectl apply -f openebs-operator.yaml
#或者使用helm安装OpenEBS
#kubectl create namespace openebs
#helm install -n openebs --namespace openebs .

3.使用默认或自定义的storageclass
kubectl apply -f openebs-storageclasses.yaml

mountOptions:
  - vers=4.0
  - noresvport

4. 创建快照(试验)
kubectl create -f snapshot.yml
使用快照创建卷



生产环境推荐直接使用裸盘,使用cstor管理
openebs运行不依赖宿主机zfs，但是依旧建议宿主机安装zfs，便于维护和故障排除
存储默认开启checksum应对劣质硬件和云厂商掩盖的数据错误,压缩,3副本冗余
支持为每个卷设定冗余级别
支持为每个卷设定QOS,通过限制CPU/MEM实现

https://docs.openebs.io/docs/next/deploycstor.html
要求每个宿主机有N个相同容量的数据盘
kubectl get disks
编辑openebs-config.yaml 
加入disk列表
