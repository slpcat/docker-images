部署Rook Operator
kubectl create -f  operator.yaml
创建Rook Cluster
kubectl create -f cluster.yaml
创建StorageClass和存储池
kubectl create -f storageclass.yaml
Rook工具箱
kubectl create -f toolbox.yaml
