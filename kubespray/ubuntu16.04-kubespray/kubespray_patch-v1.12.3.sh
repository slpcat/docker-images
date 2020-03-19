#!/bin/bash
set -ex

#clone code
git clone https://github.com/kubernetes-sigs/kubespray.git

#change to the tested version
cd kubespray
git checkout v2.8.0
cd ..

#change to private registry 
# current dir contains "kubespray"
PRIVATE_KUBE_REGISTRY="slpcat"
PRIVATE_QUAYIO_REGISTRY="slpcat"
gcr_image_files=(
./kubespray/roles/kubernetes-apps/ansible/defaults/main.yml
./kubespray/roles/download/defaults/main.yml
)

for file in ${gcr_image_files[@]} ; do
    sed -i "s/gcr.io\/google_containers/${PRIVATE_KUBE_REGISTRY}/g" $file
    sed -i "s/gcr.io\/google-containers/${PRIVATE_KUBE_REGISTRY}/g" $file
done

quay_image_files=(
./kubespray/roles/download/defaults/main.yml
./kubespray/roles/etcd/tasks/install_rkt.yml
./kubespray/roles/kubernetes/node/tasks/install_rkt.yml
./kubespray/roles/kubernetes/node/defaults/main.yml
)

for file in ${quay_image_files[@]} ; do
    sed -i "s/quay.io\/coreos\//${PRIVATE_QUAYIO_REGISTRY}\/coreos-/g" $file
    sed -i "s/quay.io\/calico\//${PRIVATE_QUAYIO_REGISTRY}\/calico-/g" $file
    sed -i "s/quay.io\/l23network\//${PRIVATE_QUAYIO_REGISTRY}\/l23network-/g" $file
    sed -i "s/quay.io\/external_storage\//${PRIVATE_QUAYIO_REGISTRY}\/external_storage-/g" $file
    sed -i "s/quay.io\/kubespray\//${PRIVATE_QUAYIO_REGISTRY}\/kubespray-/g" $file
    sed -i "s/quay.io\/jetstack\//${PRIVATE_QUAYIO_REGISTRY}\/jetstack-/g" $file
    sed -i "s/quay.io\/kubernetes-ingress-controller\//${PRIVATE_QUAYIO_REGISTRY}\/kubernetes-ingress-controller-/g" $file
done

sed -i 's/gcr.io\/kubernetes-helm/slpcat/' ./kubespray/roles/download/defaults/main.yml
sed -i 's/docker.io\/cilium/slpcat/' ./kubespray/roles/download/defaults/main.yml
sed -i 's/k8s.gcr.io/slpcat/' ./kubespray/roles/download/defaults/main.yml
#sed -i 's/^cilium_version.*$/cilium_version:\ \"v1.2\"/' ./kubespray/roles/download/defaults/main.yml

#download setting
#sed -i 's/^download_localhost.*$/download_localhost:\ True/' ./kubespray/roles/download/defaults/main.yml
#sed -i 's/^download_run_once.*$/download_run_once:\ True/' ./kubespray/roles/download/defaults/main.yml
#sed -i 's/^download_always_pull.*$/download_always_pull:\ True/' ./kubespray/roles/download/defaults/main.yml
sed -i 's/^retry_stagger.*$/retry_stagger:\ 60/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml

#change docker repo
sed -i 's/^docker_rh_repo_base_url.*$/docker_rh_repo_base_url:\ \"http:\/\/mirrors.aliyun.com\/docker-ce\/linux\/centos\/7\/\$basearch\/stable"/' ./kubespray/roles/container-engine/docker/defaults/main.yml
sed -i 's/^docker_rh_repo_gpgkey.*$/docker_rh_repo_gpgkey:\ \"http:\/\/mirrors.aliyun.com\/docker-ce\/linux\/centos\/gpg"/' ./kubespray/roles/container-engine/docker/defaults/main.yml
sed -i 's/^docker_ubuntu_repo_base_url.*$/docker_ubuntu_repo_base_url:\ \"http:\/\/mirrors.aliyun.com\/docker-ce\/linux\/ubuntu"/' ./kubespray/roles/container-engine/docker/defaults/main.yml
sed -i 's/^docker_ubuntu_repo_gpgkey.*$/docker_ubuntu_repo_gpgkey:\ \"http:\/\/mirrors.aliyun.com\/docker-ce\/linux\/ubuntu\/gpg"/' ./kubespray/roles/container-engine/docker/defaults/main.yml
sed -i 's/^docker_debian_repo_base_url.*$/docker_debian_repo_base_url:\ \"http:\/\/mirrors.aliyun.com\/docker-ce\/linux\/debian"/' ./kubespray/roles/container-engine/docker/defaults/main.yml
sed -i 's/^docker_debian_repo_gpgkey.*$/docker_debian_repo_gpgkey:\ \"http:\/\/mirrors.aliyun.com\/docker-ce\/linux\/debian\/gpg"/' ./kubespray/roles/container-engine/docker/defaults/main.yml

#change cluster congfig
sed -i 's/^ndots.*$/ndots:\ 5/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^enable_network_policy.*$/enable_network_policy:\ true/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^kube_proxy_mode.*$/kube_proxy_mode:\ ipvs/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^dns_mode.*$/dns_mode:\ coredns_dual/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^kube_version.*$/kube_version:\ v1.12.3/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^kube_network_plugin.*$/kube_network_plugin:\ cilium/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
#sed -i 's/^ingress_nginx_enabled.*$/ingress_nginx_enabled:\ true/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
#sed -i 's/^#\ ingress_nginx_host_network.*$/ingress_nginx_host_network:\ true/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
#sed -i 's/^#kube_token_auth.*$/kube_token_auth:\ true/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^#\ kubeconfig_localhost.*$/kubeconfig_localhost:\ true/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^kube_service_addresses.*$/kube_service_addresses:\ 10.233.0.0\/16/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^kube_pods_subnet.*$/kube_pods_subnet:\ 10.234.0.0\/16/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
#sed -i 's/^cert_manager_enabled.*$/cert_manager_enabled:\ true/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^dynamic_kubelet_configuration.*$/dynamic_kubelet_configuration:\ true/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
#sed -i 's/^podsecuritypolicy_enabled.*$/podsecuritypolicy_enabled:\ true/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
sed -i 's/^kube_image_repo.*$/kube_image_repo:\ \"slpcat\"/' ./kubespray/inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml

#sed -i 's/^local_volume_provisioner_enabled.*$/local_volume_provisioner_enabled:\ true/' ./kubespray/inventory/sample/group_vars/k8s-cluster/addons.yml

sed -i 's/^#kube_read_only_port.*$/kube_read_only_port:\ 10255/' ./kubespray/inventory/sample/group_vars/all/all.yml
sed -i 's/^#download_container.*/download_container:\ true/' ./kubespray/inventory/sample/group_vars/all/all.yml
sed -i 's/^#kubelet_load_modules.*$/kubelet_load_modules:\ true/' ./kubespray/inventory/sample/group_vars/all/all.yml
sed -i 's/^kubeadm_enabled.*$/kubeadm_enabled:\ false/' ./kubespray/inventory/sample/group_vars/all/all.yml

sed -i 's/^#etcd_memory_limit.*$/etcd_memory_limit:\ "0"/' ./kubespray/inventory/sample/group_vars/etcd.yml
sed -i 's/^#etcd_quota_backend_bytes.*$/etcd_quota_backend_bytes:\ "8G"/' ./kubespray/inventory/sample/group_vars/etcd.yml

sed -i 's/^etcd_events_cluster_enabled.*$/etcd_events_cluster_enabled:\ true/' ./kubespray/roles/kubespray-defaults/defaults/main.yaml
sed -i 's/^etcd_events_cluster_enabled.*$/etcd_events_cluster_enabled:\ true/' ./kubespray/roles/etcd/defaults/main.yml
sed -i 's/^etcd_events_cluster_setup.*$/etcd_events_cluster_setup:\ true/' ./kubespray/roles/etcd/defaults/main.yml

sed -i 's/^cilium_memory_limit.*$/cilium_memory_limit:\ 2Gi/' ./kubespray/roles/network_plugin/cilium/defaults/main.yml
sed -i 's/^cilium_cpu_limit.*$/cilium_cpu_limit:\ 2/' ./kubespray/roles/network_plugin/cilium/defaults/main.yml

sed -i 's/^kube_controller_pod_eviction_timeout.*$/kube_controller_pod_eviction_timeout:\ 1m0s/' ./kubespray/roles/kubernetes/master/defaults/main.yml

#change local-volume-provisioner
#echo 'reclaimPolicy: Retain' >> ./kubespray/roles/kubernetes-apps/external_provisioner/local_volume_provisioner/templates/local-volume-provisioner-sc.yml.j2

#change download url
sed -i 's/^hyperkube_download_url.*$/hyperkube_download_url:\ \"https:\/\/github.com\/slpcat\/fai_config\/raw\/master\/extra\/kubernetes\/k8s-release\/v1.12.3\/hyperkube\"/' ./kubespray/roles/download/defaults/main.yml
sed -i 's/^kubeadm_download_url.*$/kubeadm_download_url:\ \"https:\/\/github.com\/slpcat\/fai_config\/raw\/master\/extra\/kubernetes\/k8s-release\/v1.12.3\/kubeadm\"/' ./kubespray/roles/download/defaults/main.yml

#Azure cloudprovider
#inventory/sample/group_vars/all.yml
#azure_cloud: AzureChinaCloud
#./roles/kubernetes/node/templates/azure-cloud-config.j2
#  "cloud": "{{ azure_cloud }}",

#kubelet tuning https://kubernetes.io/docs/reference/generated/kubelet/
# 
#roles/kubernetes/node/templates/kubelet.standard.env.j2
#roles/kubernetes/node/defaults/main.yml
sed -i 's/^kubelet_max_pods.*$/kubelet_max_pods:\ 210/' ./kubespray/roles/kubernetes/node/defaults/main.yml
sed -i 's/^kubelet_status_update_frequency.*$/kubelet_status_update_frequency:\ 20s/' ./kubespray/roles/kubernetes/node/defaults/main.yml
sed -i "s/kubelet_custom_flags.*$/kubelet_custom_flags\:\ \[--event-burst=50\ --event-qps=30\ --image-gc-high-threshold=80\ --image-gc-low-threshold=40\ --image-pull-progress-deadline=2h\ --kube-api-burst=2000\ --kube-api-qps=1000\ --minimum-image-ttl-duration=72h\ --allowed-unsafe-sysctls=net.*\ --protect-kernel-defaults=false\ --registry-burst=200\ --registry-qps=100\ --serialize-image-pulls=false\ ]/" ./kubespray/roles/kubernetes/node/defaults/main.yml

#feature_gates tuning
#GPU support --feature-gates=DevicePlugins=true
#sed -i '/^kube_feature_gates/a\  - "ReadOnlyAPIDataVolumes=false"\n  - "ExpandPersistentVolumes=true"\n  - "DevicePlugins=true"' ./kubespray/roles/kubespray-defaults/defaults/main.yaml
