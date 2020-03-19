#!/bin/bash

if [ $# -eq 0 ] ; then
    echo "[Invalid Param], use sudo ./install-k8s-log.sh {your-k8s-cluster-id}"
    exit 1
fi

clusterName=$(echo $1 | tr '[A-Z]' '[a-z]')
curl --connect-timeout 5  http://100.100.100.200/latest/meta-data/region-id

if [ $? != 0 ]; then
    echo "[FAIL] ECS meta server connect fail, only support alibaba cloud k8s service"
    exit 1
fi

regionId=`curl http://100.100.100.200/latest/meta-data/region-id`
aliuid=`curl http://100.100.100.200/latest/meta-data/owner-account-id`

helmPackageUrl="http://logtail-release-$regionId.oss-$regionId.aliyuncs.com/kubernetes/alibaba-cloud-log.tgz"
wget $helmPackageUrl -O alibaba-cloud-log.tgz
if [ $? != 0 ]; then
    echo "[FAIL] download alibaba-cloud-log.tgz from $helmPackageUrl failed"
    exit 1
fi

project="k8s-log-"$clusterName
if [ $# -ge 2 ]; then
    project=$2
fi

echo [INFO] your k8s is using project : $project

helm install alibaba-cloud-log.tgz --name alibaba-log-controller \
    --set ProjectName=$project \
    --set RegionId=$regionId \
    --set InstallParam=$regionId \
    --set MachineGroupId="k8s-group-"$clusterName \
    --set Endpoint=$regionId"-intranet.log.aliyuncs.com" \
    --set AlibabaCloudUserId=":"$aliuid \
    --set LogtailImage.Repository="registry.$regionId.aliyuncs.com/log-service/logtail" \
    --set ControllerImage.Repository="registry.$regionId.aliyuncs.com/log-service/alibabacloud-log-controller"

installRst=$?

if [ $installRst -eq 0 ]; then
    echo "[SUCCESS] install helm package : alibaba-log-controller success."
    exit 0
else
    echo "[FAIL] install helm package failed, errno " $installRst
    exit 0
fi