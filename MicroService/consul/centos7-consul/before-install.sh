#!/bin/bash

groupadd -g 987 consul
useradd -u 987 -g 987 -M -c "Consul service mesh" -d /var/lib/consul -s /sbin/nologin consul
 
if [ ! -e /etc/consul.d/ ]; then
            mkdir -p /etc/consul.d/
            chmod -R 644 /etc/consul.d/
            chown consul:consul /etc/consul.d/
fi

if [ ! -e /var/lib/consul ]; then
            mkdir -p /var/lib/consul
            chmod -R 640 /var/lib/consul
            chown consul:consul /var/lib/consul
fi
