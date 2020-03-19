#!/bin/bash

if [ $# -le 4 ] ; then
    echo "[Invalid Param], use sudo ./install-k8s-log.sh {your-project-suffix} {regionId} {aliuid} {accessKeyId} {accessKeySecret}"
    exit 1
fi

project="k8s-log-custom-"$1
regionId=$2
aliuid=$3
accessKeyId=$4
accessKeySecret=$5

helmPackageUrl="http://logtail-release-$regionId.oss-$regionId.aliyuncs.com/kubernetes/alibaba-cloud-log.tgz"
wget $helmPackageUrl -O alibaba-cloud-log.tgz
if [ $? != 0 ]; then
    echo "[FAIL] download alibaba-cloud-log.tgz from $helmPackageUrl failed"
    exit 1
fi

helm install alibaba-cloud-log.tgz --name alibaba-log-controller \
    --set ProjectName=$project \
    --set RegionId=$regionId \
    --set InstallParam=$regionId"_internet" \
    --set MachineGroupId="k8s-group-custom-"$1 \
    --set Endpoint=$regionId".log.aliyuncs.com" \
    --set AlibabaCloudUserId=":"$aliuid \
    --set AlibabaCloudK8SCluster="false" \
    --set Privileged="true" \
    --set AccessKeyId=$accessKeyId \
    --set AccessKeySecret=$accessKeySecret \
    --set LogtailImage.Repository="registry.$regionId.aliyuncs.com/log-service/logtail" \
    --set ControllerImage.Repository="registry.$regionId.aliyuncs.com/log-service/alibabacloud-log-controller"

installRst=$?

if [ $installRst -eq 0 ]; then
    echo [INFO] your k8s is using project : $project, region : $regionId, aliuid : $aliuid, accessKeyId : $accessKeyId
    echo "[SUCCESS] install helm package : alibaba-log-controller success."
    exit 0
else
    echo "[FAIL] install helm package failed, errno " $installRst
    exit 0
fi