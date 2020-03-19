#!/bin/bash

NAMESPACE=${NAMESPACE:-"ceph"}
TIMEOUT=${TIMEOUT:-30}
UPGRADE_ORDER=${UPGRADE_ORDER:-"mgr mon osd mds rgw rbd-provisioner moncheck"}
KUBECTL=${KUBECTLL-"kubectl"}

function pod_is_ready {
    pod=$1
    ready=$(kubectl get pod ${pod} --namespace=${NAMESPACE} -o template --template="{{ (index .status.containerStatuses 0).ready }}")
    if [ $? -ne 0 ]; then 
         # bad pod
        false
    fi

    if [ ${ready} == "true" ]; then 
       echo "Pod ${pod} is ready"
       true
    else
       false
    fi
}

function wait_for_new_pod {
    i=${TIMEOUT}
    while [ $i -gt 0 ]; do
        running_pods=$(kubectl get pod --namespace=${NAMESPACE} -l application=ceph,component=${component} -o template --template="{{range .items}} {{.metadata.name }} {{end}}")
        for n in ${running_pods}; do
            re="\b${n}\b"
            if [[ ! ${cur_pods} =~ $re ]]; then 
                echo -n "Wait for Pod ${n} to be ready: "
                if pod_is_ready ${n}; then
                    return
                fi
            fi
        done
        sleep 1
        i=$(( $i-1 ))
    done
    echo
}

function wait_for_pod_deleted {
    pod=$1
    re="\b${pod}\b"
    i=${TIMEOUT}
    echo -n "Wait for Pod ${pod} to be removed: "
    while [ $i -gt 0 ]; do
        running_pods=$(kubectl get pod --namespace=${NAMESPACE} -l application=ceph,component=${component} -o template --template="{{range .items}} {{.metadata.name }} {{end}}")
        if [[ ! ${running_pods} =~ $re ]]; then 
            echo "Pod ${pod} removed"
            return
        fi
        sleep 1
        i=$(( $i-1 ))
   done
}

function main {
    for component in ${UPGRADE_ORDER}; do
        echo "Upgrading ${component}"
        pods=$(kubectl get pod --namespace=${NAMESPACE} -l application=ceph,component=${component} -o template --template="{{range .items}} {{.metadata.name }} {{end}}")
        for p in ${pods}; do
            cur_pods=$(kubectl get pod --namespace=${NAMESPACE} -l application=ceph,component=${component} -o template --template="{{range .items}} {{.metadata.name }} {{end}}")
            echo -n "Deleting pod ${p}: "
            ${KUBECTL} delete pod --namespace=${NAMESPACE} ${p}
            wait_for_pod_deleted ${p}
            wait_for_new_pod
        done
    done
}

main

