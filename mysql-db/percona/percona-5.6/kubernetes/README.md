1.单实例，主库，持久存储，不可水平伸缩
mysql-configmap.yml mysql-statfulset.yml mysql-svc.yml
2.多实例，一个主库，主库读写，多个从库，从库只读，从库可水平伸缩，持久存储
mysql-configmap-master.yml mysql-configmap-slave.yml mysql-statfulset-scale.yml mysql-svc-scale.yml
