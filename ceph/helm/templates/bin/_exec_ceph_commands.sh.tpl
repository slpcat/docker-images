#!/bin/bash

set -ex
export LC_ALL=C

MON_NAME=$(kubectl get pods --namespace=${NAMESPACE} -l application=ceph,component=mon -o template --template="{{`{{ with index .items 0}}`}}{{`{{ .metadata.name}}`}}{{`{{end}}`}}")

# Define field separator to ';' and
# store commands in a bash array
IFS=';' read -ra CEPH_COMMANDS <<< "${CEPH_COMMANDS_LIST}"
for ceph_command in "${CEPH_COMMANDS[@]}"; do
    kubectl --namespace=${NAMESPACE} exec ${MON_NAME} -c ceph-mon -- $ceph_command
done
