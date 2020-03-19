#!/bin/bash

#CommandLine Tools: aliyun jq pigz
#https://github.com/aliyun/aliyun-cli/releases
#https://help.aliyun.com/document_detail/121258.html?spm=a2c4g.11186623.4.2.2ba47888ulIxFk
#https://github.com/stedolan/jq/releases
#yum install -y pigz or apt-get install -y pigz

RegionId="cn-beijing"
DomainNameList="a.example.com b.example.com"
DownloadPath="./cdnlog"

#attention: UTC time for API and CST time for Logfile!
#use UTC time here

StartTime="2019-08-01T09:00:00Z"
EndTime="2019-08-01T09:15:00Z"

#*******LOG Downloader******

#PageNumber=1
PageSize=20000

GenDir () {
if [ -d $DownloadPath ]; then
   true
else 
   mkdir -p $DownloadPath
fi

for DomainName in $DomainNameList
do
mkdir -p $DownloadPath/$DomainName
done

}

GenLogPathList() {
for DomainName in $DomainNameList
do
  aliyun cdn DescribeCdnDomainLogs --DomainName $DomainName --StartTime $StartTime --EndTime $EndTime --PageSize $PageSize |jq '.DomainLogModel.DomainLogDetails.DomainLogDetail[].LogPath' > $DownloadPath/$DomainName/LogPathList

sed -i '' /^$/d $DownloadPath/$DomainName/LogPathList
sed -i '' s/\"//g $DownloadPath/$DomainName/LogPathList
sed -i '' 's/^/https:\/\/&/g' $DownloadPath/$DomainName/LogPathList
done
}

GenLogNameList() {
for DomainName in $DomainNameList
do
  aliyun cdn DescribeCdnDomainLogs --DomainName $DomainName --StartTime $StartTime --EndTime $EndTime --PageSize $PageSize|jq '.DomainLogModel.DomainLogDetails.DomainLogDetail[].LogName'> $DownloadPath/$DomainName/LogNameList

sed -i '' /^$/d $DownloadPath/$DomainName/LogNameList
sed -i '' s/\"//g $DownloadPath/$DomainName/LogNameList
done
}


DowloadLogFile() {
for DomainName in $DomainNameList
do
paste $DownloadPath/$DomainName/LogNameList $DownloadPath/$DomainName/LogPathList | while read LINE
do
echo Downloading file `echo $LINE |awk '{print $1}'`
wget -O $DownloadPath/$DomainName/$LINE
done
done
}

DecompressLog() {

if [ $(which pigz) ] ;then
UNZIP="pigz -d" 
else
UNZIP="gzip -d"
fi
for DomainName in $DomainNameList
do
for file in `ls $DownloadPath/$DomainName/*.gz`
do
echo Decompressing Logfile $file
$UNZIP -v $file
done
done
}

GenDir

GenLogPathList

GenLogNameList

DowloadLogFile

DecompressLog
