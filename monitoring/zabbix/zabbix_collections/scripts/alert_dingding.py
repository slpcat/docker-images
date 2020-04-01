#!/usr/bin/env python
# -*- coding:utf-8 -*-

import requests
import json
import sys
import os
import datetime

#tokens

token_list = [
    "123456789abcdef123456789",
]

index = int(sys.argv[1])
text = sys.argv[2]

weburl = "https://oapi.dingtalk.com/robot/send?access_token="

webhook = weburl + token_list[index]

data = {
    "msgtype": "markdown",
    "markdown": {
        "title": "监控报警",
        "text": text
    },
}

headers = {'Content-Type': 'application/json'}
x = requests.post(url=webhook, data=json.dumps(data), headers=headers)

if os.path.exists("/tmp/zabbix_dingding.log"):
    f = open("/tmp/zabbix_dingding.log", "a+")
else:
    f = open("/tmp/zabbix_dingding.log", "w+")
f.write("\n" + "--" * 30)
if x.json()["errcode"] == 0:
    f.write("\n" + str(datetime.datetime.now()) + "    " + str(index) + "    " +
            "发送成功" + "\n" + str(text))
    f.close()
else:
    f.write("\n" + str(datetime.datetime.now()) + "    " + str(index) + "    " +
            "发送失败" + "\n" + str(text))
    f.close()
