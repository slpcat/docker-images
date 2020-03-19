#!/bin/bash 

  usename='example_username' 

  apikey='example_apikey' 

  date=`env LANG="en_US.UTF-8" date -u "+%a, %d %b %Y %H:%M:%S GMT"` 

  password=`echo -en "$date" | openssl dgst -sha1 -hmac "$apikey" -binary | openssl enc -base64` 

  curl -i --url "http://open.chinanetcenter.com/CloudEye/CeQueryStatisticsSource" \ 

  -X POST \ 

  -u $usename:$password \ 

  -H "Date: $date" \ 

  -H 'Accept: application/json' \ 

  -H 'Content-Type: application/json' \ 

  -d '{"type":"5","dateBegin":"2016-10-08   07:20:02","taskId":"717db918dc514537b65c1f6bf16caa05"}' 

  echo `date` 

 
