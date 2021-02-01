#!/bin/bash

kubectl delete -f kubernetes/mutatingwebhook-ca-bundle.yaml
kubectl delete -f kubernetes/service.yaml
kubectl delete -f kubernetes/deployment.yaml
kubectl delete secret -n kube-system lxcfs-admission-webhook-certs

