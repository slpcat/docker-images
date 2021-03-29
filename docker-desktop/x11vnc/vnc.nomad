job "vnc-desktop" {
  #region = "us-east1"
  datacenters = ["dc1", "lon1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  #Nomad provides the service, system and batch schedulers.
  type = "service"

  group "vnc-desktop" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "vnc-desktop" {

      driver = "docker"

      env {
        "RESOLUTION" = "1280x1024"
        "HTTP_PASSWORD" = "mypassword"
        #"PASSWORD" = "password"
      }

      logs{
        max_files=5
        max_file_size=20
      }

      config {
        image = "dorowu/ubuntu-desktop-lxde-vnc"
        force_pull = false
        #command = "my-command"
        #args = [
        #  "-bind", "${NOMAD_PORT_http}",
        #  "${nomad.datacenter}",
        #  "${MY_ENV}",
        #  "${meta.foo}",
        #]
        #shm_size = 134217728
        #only for overlay over xfs with 'pquota' mount option
        #storage_opt = {
        #  size = "10G"
        #}

        volumes = [
          # Use absolute paths to mount arbitrary paths on the host
          "/dev/shm:/dev/shm"
        ]
        #volume_driver = "pxd"

        #extra_hosts = ["host1.com:1.2.3.4"]

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

        port_map {
          web = 80
        }
      }

      service {
        name = "vnc"
        port = "web"
        tags = [
          "online",
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
        cpu = 100 # 500 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
          port "web" {
            #static = 10050
          }
        }
      }
    }
  }
}
