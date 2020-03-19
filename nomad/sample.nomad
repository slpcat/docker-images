job "web" {
  #region = "alicloud-beijing"
  datacenters = ["dc1", "zone-f"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  constraint {
    attribute = "${meta.department}"
    value     = "im-group"
  }

  #constraint {
  #  attribute = "${meta.storage}"
  #  value     = "ssd"
  #}

  #constraint {
  #  attribute = "${meta.rack}"
  #  value     = "B001"
  #}

  constraint {
    attribute = "${attr.unique.network.ip-address}"
    value     = "172.16.1.1"
  }

  #Nomad provides the service, system and batch schedulers.
  type = "service"

  update {
    max_parallel      = 3
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = true
    canary            = 1
    stagger           = "30s"
  }

  group "webserber" {
    count = 3
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "web" {
      artifact {
        source      = "https://example.com/file.tar.gz"
        destination = "local/app"
        options {
          checksum = "md5:df6a4178aec9fbdc1d6d7e3634d1bc33"
        }
      }

      driver = "docker"

      env {
        "APP" = "nginx"
      }

      logs{
        max_files=5
        max_file_size=20
      }

      config {
        image = "registry.cn-beijing.aliyuncs.com/webserver"
        force_pull = false
        network_mode = "host"
        #command = "my-command"
        #args = [
        #  "-bind", "${NOMAD_PORT_http}",
        #  "${nomad.datacenter}",
        #  "${MY_ENV}",
        #  "${meta.foo}",
        #]
        #shm_size = 134217728

        volumes = [
          # Use absolute paths to mount arbitrary paths on the host
          "/data/dockerSrc/$servName:/workspace/webapps/$servName",
          "/data/logs/${servName}${i}:/workspace/logs"
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

        #port_map {
        #  http = 80
        #}
      }

      service {
        name = "web"
        port = "http"
        port = "metrics"
        tags = [
          "online",
          "prometheus-target",
          "traefik.enable=true",
          "traefik.frontend.entryPoints=http",
          "traefik.protocol=http",
          "traefik.weight=10",
          "traefik.backend.circuitbreaker.expression=NetworkErrorRatio() > 0.5",
          "traefik.backend.loadbalancer.method=drr",
          "traefik.backend.maxconn.amount=100",
          "traefik.backend.maxconn.extractorfunc=client.ip",
          "traefik.frontend.passHostHeader=true",
          "traefik.frontend.priority=10",
          "traefik.frontend.rule=Host:example.com"
          ]

        check {
          name = "alive"
          type = "tcp"
          interval = "10s"
          timeout = "5s"
        }
      }

      kill_timeout = "20s"
      resources {
        cpu = 2000
        memory = 4096
        network {
          mbits = 100
          port "http" {
            #static = 9088
          }
          port "sentry" {
            #static = 20010
          }
        }
      }
    }
  }
}
