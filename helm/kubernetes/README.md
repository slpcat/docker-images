site https://github.com/kubernetes/helm
wget https://kubernetes-helm.storage.googleapis.com/helm-v2.8.2-linux-amd64.tar.gz

install steps
自Kubernetes 1.6版本开始，API Server启用了RBAC授权。而目前的Tiller部署没有定义授权的ServiceAccount，这会导致访问API Server时被拒绝。我们可以采用如下方法，明确为Tiller部署添加授权。
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

请执行如下命令利用阿里云的镜像来配置 Helm
helm init --upgrade -i slpcat/tiller:v2.9.1 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
2.11安装
https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
helm init --upgrade -i slpcat/tiller:v2.11.0 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
#helm init --canary-image --tiller-image 

helm3 只需一个客户端文件，不需要tiller
helm search
若要更新charts列表以获取最新版本
helm repo update 
若要查看在群集上安装的Charts列表
helm list 
helm ls

示例

#helm repo add stable https://kubernetes-charts.storage.googleapis.com
#helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
helm repo add apphub https://apphub.aliyuncs.com
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm repo add gresearch https://g-research.github.io/charts/
helm repo add stable http://mirror.azure.cn/kubernetes/charts
helm repo add incubator http://mirror.azure.cn/kubernetes/charts-incubator
helm repo add kubeless-functions-charts https://kubeless-functions-charts.storage.googleapis.com
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add openebs-charts https://openebs.github.io/charts/
helm repo add fabric8 https://fabric8.io/helm
helm repo add gitlab https://charts.gitlab.io
# Add Helm StackStorm repository
helm repo add stackstorm https://helm.stackstorm.com/
helm repo add jenkins-x	https://chartmuseum.build.cd.jenkins-x.io
helm repo add jenkinsci https://charts.jenkins.io
helm repo add openfaas https://openfaas.github.io/faas-netes
helm repo add monocular https://kubernetes-helm.github.io/monocular
helm repo add rook-beta https://charts.rook.io/beta
helm repo add agones https://agones.dev/chart/stable
helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com
helm repo add appscode https://charts.appscode.com/stable/
helm repo add m3db https://s3.amazonaws.com/m3-helm-charts-repository/stable
helm repo add kong https://charts.konghq.com
helm repo add jetstack https://charts.jetstack.io
helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com

# Add Helm StackStorm repository
helm repo add stackstorm https://helm.stackstorm.com/
helm repo add presslabs https://presslabs.github.io/charts
#helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
helm repo add nvidia https://nvidia.github.io/gpu-operator
#Elasticsearch operator
helm repo add akomljen-charts https://raw.githubusercontent.com/komljen/helm-charts/master/charts/
#helm install presslabs/mysql-operator --name mysql-operator
helm repo add bitnami https://charts.bitnami.com/bitnami
#helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
#helm repo add aliyun https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
helm install --name wordpress-test --set "persistence.enabled=false,mariadb.persistence.enabled=false" stable/wordpress
#https://kubeapps.com/ 你可以寻找和发现已有的Charts
helm repo add cilium https://helm.cilium.io/
