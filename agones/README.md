kubectl create namespace agones-system
kubectl apply -f https://github.com/GoogleCloudPlatform/agones/raw/release-0.5.0/install/yaml/install.yaml

helm repo add agones https://agones.dev/chart/stable
helm install --name my-release --namespace agones-system agones/agones
