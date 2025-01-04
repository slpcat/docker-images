# vault.hcl - Vault的配置文件
ui            = true
cluster_name = "cluter_vault"
disable_cache = true
default_lease_ttl = "168h"
max_lease_ttl = "720h"
#cluster_addr  = "https://127.0.0.1:8201"
#api_addr      = "https://127.0.0.1:8200"
disable_mlock = true

#telemetry {
#  statsite_address = "127.0.0.1:8125"
#  disable_hostname = true
#}

storage "file" {
  path = "/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}
