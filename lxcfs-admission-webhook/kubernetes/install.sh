#!/bin/bash

./kubernetes/webhook-create-signed-cert.sh --namespace kube-system
kubectl get secret -n kube-system lxcfs-admission-webhook-certs

kubectl create -f kubernetes/deployment.yaml
kubectl create -f kubernetes/service.yaml
cat ./kubernetes/mutatingwebhook.yaml | ./kubernetes/webhook-patch-ca-bundle.sh > ./kubernetes/mutatingwebhook-ca-bundle.yaml
kubectl create -f kubernetes/mutatingwebhook-ca-bundle.yaml

