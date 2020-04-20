datacenter = "dc1"
bind_addr = "172.16.0.1"
client_addr = "0.0.0.0"
leave_on_terminate = false
reconnect_timeout = "96h"
retry_interval = "20s"
data_dir = "/var/lib/consul"
retry_join = ["172.16.1.2", "172.16.1.3", "172.16.1.4"]
performance {
  raft_multiplier = 1
}
enable_syslog = true
log_level = "INFO"
enable_local_script_checks = true
disable_update_check = true
disable_remote_exec = true
recursors = ["114.114.114.114", "8.8.8.8"]
dns_config {
  recursor_timeout = "4s"
  allow_stale = true
  max_stale = "48h"
  node_ttl = "10m"
  service_ttl {
    "*" = "10s",
    "web" = "30s",
    "db*" = "10s",
    "db-master" = "3s"
    }
  enable_truncate = true
  only_passing = false
  recursor_timeout = "2s"
  udp_answer_limit = 3
}
