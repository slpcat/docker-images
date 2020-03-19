job "zabbix-agent" {
  #region = "us-east1"
  datacenters = ["dc1", "lon1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  #Nomad provides the service, system and batch schedulers.
  type = "system"

  group "zabbix-agent" {

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "zabbi-agent" {
      #artifact {
      #  source      = "https://example.com/file.tar.gz"
      #  destination = "local/some-directory"
      #  options {
      #    checksum = "md5:df6a4178aec9fbdc1d6d7e3634d1bc33"
      #  }
      #}

      #template {
      #  data = <<EOH
      #  ---
      #   node_dc:    {{ env "node.datacenter" }}
      #   node_cores: {{ env "attr.cpu.numcores" }}
      #  EOH
      #  destination = "local/file.yml"
      #  change_mode   = "signal"
      #  change_signal = "SIGINT"
      #}

      driver = "docker"

      env {
        "ZA_Server" = "127.0.0.1,zabbix-server.monitoring"
        "ZA_ServerActive" = "zabbix-server.monitoring"
      }

      logs{
        max_files=5
        max_file_size=20
      }

      config {
        image = "monitoringartist/dockbix-agent-xxl-limited"
        force_pull = false
        privileged = true
        network_mode = "host"
        pid_mode = "host"

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
          "/:/rootfs",
          "/var/run:/var/run"
        ]

        #extra_hosts = ["host1.com:1.2.3.4"]

        #labels {
          #log-pilot log collector
          #aliyun.logs.catalina = "stdout"
          #aliyun.logs.access = "/usr/local/tomcat/logs/localhost_access_log*.txt"
        #}

      }

      service {
        name = "zabbix-agent"
        port = "agent"
        tags = [
          "online"
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
        cpu = 500 # 500 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
          port "agent" {
            static = 10050
          }
        }
      }
    }
  }
}
