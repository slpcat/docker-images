#! /bin/bash

vault kv put secret/rabbit/cookie cookie=rabbitmq
vault kv put secret/rabbit/admin username=guest password=guest
