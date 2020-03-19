# prom2zabbix

## Overview

integration for discovery a send prometheus metrics to zabbix

## Description

Basic images are from quay.io/prometheus

Monitoring nginx metric uses this image [https://hub.docker.com/r/sophos/nginx-vts-exporter/]

## Supported platforms

* Centos 7.x x86_64 & python 3.4 & prometheus 1.8

## Setup

* install python34 and libs

```
linux# yum install python34 python34-urllib3 python34-requests -y
```

## Usage

### Discovery items

service: up

```
[root@linux prom2zabbix]# ./prom2zabbix.py --action=discovery --service up
{
    "data": [
    {
	"{#ITEMNAME}": "node-docker",
	"{#ITEMSTATUS}": "up"
    },
    {
	"{#ITEMNAME}": "node-exporter",
	"{#ITEMSTATUS}": "up"
    },
    {
	"{#ITEMNAME}": "prometheus",
	"{#ITEMSTATUS}": "up"
    },
    {
	"{#ITEMNAME}": "nginx-vts-exporter",
	"{#ITEMSTATUS}": "up"
    }

    ]
}
```

service: nginx_server_requests

```
[root@linux prom2zabbix]# ./prom2zabbix.py --action=discovery --service nginx_server_requests
{
    "data": [
    {
	"{#ITEMNAME}": "web.example.com"
    },
    {
	"{#ITEMNAME}": "prometheus.example.com"
    },
    {
	"{#ITEMNAME}": "10.211.1.99"
    },
    {
	"{#ITEMNAME}": "prometheus-s1-node-exporter"
    },
    {
	"{#ITEMNAME}": "*"
    }

    ]
}
```

### get values for item

* get up value

```
[root@linux prom2zabbix]# ./prom2zabbix.py --action=get --service up --item node-docker
1
```

* get nginx stats

```
[root@linux prom2zabbix]# ./prom2zabbix.py --action=get --service nginx_server_requests --debug 0 --itemname "web.example.com--2xx"
1018
```

## Authors

* Patrik Majer (@czhujer) <patrik.majer@sugarfactory.cz>

## Docs / Links

* https://prometheus.io/docs/prometheus/latest/installation/

* https://quay.io/organization/prometheus

* https://github.com/vozlt/nginx-module-vts

