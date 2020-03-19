1.redis单纯用作缓存，无存储，单实例，最简单，效率最高
redis-configmap.yml redis-deploy.yml redis-svc.yml
2.redis用作存储，有持久化存储，单实例
redis-configmap.yml redis-master-statfulset.yml redis-master-svc.yml
3.redis分布式集群，有持久化存储，多实例，可伸缩
redis-configmap.yml redis-data-pvc.yml redis-master-statfulset.yml redis-master-svc.yml
redis-slave-statefulset.yml redis-slave-svc.yml
redis-sentinel-statefulset.yml redis-sentinel-svc.yaml
