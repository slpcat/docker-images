kubectl create secret docker-registry ecr-secret \
  --docker-server=https://ACCOUNT-A-ID.dkr.ecr.region.amazonaws.com \
  --docker-username=AWS \
  --docker-password=<AccessKeyId>:<SecretAccessKey> \
  --docker-email=unused \
  --dry-run=client -o yaml | kubectl apply -f -
