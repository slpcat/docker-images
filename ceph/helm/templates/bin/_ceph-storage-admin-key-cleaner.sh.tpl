#!/bin/bash

set -ex

for secret in $CEPH_ADMIN_SECRETS_NAME; do
  kubectl delete secret \
  --namespace ${DEPLOYMENT_NAMESPACE} \
  --ignore-not-found=true \
  ${secret}
done

kubectl delete secret \
  --namespace ${DEPLOYMENT_NAMESPACE} \
  --ignore-not-found=true \
  ${PVC_CEPH_STORAGECLASS_ADMIN_SECRET_NAME}
