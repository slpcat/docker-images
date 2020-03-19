job "log-pilot" {
  #region = "alicloud-beijing"
  datacenters = ["dc1", "zone-f"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  #constraint {
  #  attribute = "${meta.department}"
  #  value     = "research-center"
  #}

  #constraint {
  #  attribute = "${meta.storage}"
  #  value     = "ssd"
  #}

  #constraint {
  #  attribute = "${meta.rack}"
  #  value     = "B001"
  #}

  #constraint {
  #  attribute = "${attr.unique.network.ip-address}"
  #  value     = "1.2.3.4"
  #}

  #Nomad provides the service, system and batch schedulers.
  type = "system"

  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = true
    canary            = 0
    stagger           = "30s"
  }

  group "log-pilot" {

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    #ephemeral_disk {
    #  driver = "zfs"
    #  attributes {
    #  record_size = 16
    #  #more file system attributes
    #  }
    #}

    task "log-pilot" {

      driver = "docker"

      env {
        "LOGGING_OUTPUT" = "kafka"
        "KAFKA_BROKERS" = "kafka1:9092,kafka2:9092"
        "KAFKA_VERSION" = "0.10.0"
        "KAFKA_CLIENT_ID" = "beats"
        "KAFKA_BROKER_TIMEOUT" = "60"
        #"KAFKA_KEEP_ALIVE" = "10m"
        "KAFKA_REQUIRE_ACKS" = "0"
        "NODE_NAME" = "${attr.unique.network.ip-address}"
      }

      logs{
        max_files=5
        max_file_size=20
      }

      config {
        image = "registry.cn-hangzhou.aliyuncs.com/acs/log-pilot:0.9.5-filebeat"
        force_pull = false
        #network_mode = "host"
        #command = "my-command"
        #args = [
        #  "-bind", "${NOMAD_PORT_http}",
        #  "${nomad.datacenter}",
        #  "${MY_ENV}",
        #  "${meta.foo}",
        #]
        #shm_size = 134217728

        cap_add = [
          "SYS_ADMIN",
        ]

        volumes = [
          # Use absolute paths to mount arbitrary paths on the host
          "/var/run/docker.sock:/var/run/docker.sock",
          "/var/log/filebeat:/var/log/filebeat",
          "/var/lib/filebeat:/var/lib/filebeat",
          "/:/host:ro",
          "/etc/localtime:/etc/localtime"
        ]

        sysctl {
          net.ipv4.tcp_syncookies = "0"
          net.ipv4.ip_local_port_range = "1024 65535"
          net.core.somaxconn = "65535"
          net.ipv4.ip_unprivileged_port_start = "0"
          net.ipv4.tcp_tw_reuse = "2"
          net.ipv4.tcp_fin_timeout = "20"
          net.ipv4.tcp_keepalive_intvl = "10"
          net.ipv4.tcp_keepalive_probes = "2"
          net.ipv4.tcp_keepalive_time = "120"
          net.ipv4.tcp_ecn = "1"
          net.ipv4.tcp_max_syn_backlog = "65536"
          net.ipv4.tcp_rfc1337 = "1"
          net.ipv4.tcp_slow_start_after_idle = "0"
          net.ipv4.tcp_fack = "1"
          net.ipv4.tcp_max_tw_buckets = "1048576"
          net.ipv4.tcp_fastopen = "3"
          net.ipv4.icmp_ratelimit = "100"
          net.ipv4.tcp_abort_on_overflow = "1"
          net.ipv4.tcp_adv_win_scale = "2"
          net.ipv4.tcp_retries2 = "8"
          net.ipv4.tcp_syn_retries = "3"
          net.ipv4.tcp_synack_retries = "2"
          net.unix.max_dgram_qlen = "512"
          net.ipv4.tcp_fwmark_accept = "1"
          net.ipv4.fwmark_reflect = "1"
        }

        #labels {
          #log-pilot log collector
          #aliyun.logs.catalina = "stdout"
          #aliyun.logs.access = "/usr/local/tomcat/logs/localhost_access_log*.txt"
        #}

      }

      service {
        name = "log-pilot"
        tags = [
          "online"
          ]

        #check {
        #  name = "alive"
        #  type = "tcp"
        #  interval = "10s"
        #  timeout = "5s"
        #}
      }

      kill_timeout = "20s"
      resources {
        cpu = 500
        memory = 1024
        network {
          mbits = 100
        }
      }
    }
  }
}
