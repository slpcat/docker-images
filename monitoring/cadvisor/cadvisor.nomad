job "cadvisor" {
  #region = "us-east1"
  datacenters = ["dc1", "lon1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  #Nomad provides the service, system and batch schedulers.
  type = "system"

  group "cadvisor" {

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "cadvisor" {

      driver = "docker"

      logs{
        max_files=5
        max_file_size=20
      }

      config {
        image = "google/cadvisor:latest"
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
        port_map {
          metrics = 8080
        }
        volumes = [
          # Use absolute paths to mount arbitrary paths on the host
          "/:/rootfs",
          "/var/run:/var/run",
          "/sys:/sys",
          "/var/lib/docker/:/var/lib/docker",
          "/dev/disk/:/dev/disk"
        ]

        #extra_hosts = ["host1.com:1.2.3.4"]

        #labels {
          #log-pilot log collector
          #aliyun.logs.catalina = "stdout"
          #aliyun.logs.access = "/usr/local/tomcat/logs/localhost_access_log*.txt"
        #}

      }

      service {
        name = "cadvisor"
        port = "metrics"
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
          port "metrics" {}
        }
      }
    }
  }
}
