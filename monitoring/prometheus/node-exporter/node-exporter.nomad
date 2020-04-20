job "node-exporter" {
  #region = "us-east1"
  datacenters = ["dc1", "lon1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  #Nomad provides the service, system and batch schedulers.
  type = "system"

  group "node-exporter" {

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "node-exporter" {

      driver = "docker"

      logs{
        max_files=5
        max_file_size=20
      }

      config {
        image = "prom/node-exporter:v0.17.0"
        force_pull = false
        privileged = true
        network_mode = "host"
        pid_mode = "host"

        #command = "my-command"
        args = [
          #"--path.procfs='/host/proc'",
          #"--path.sysfs='/host/sys'",
          "--path.rootfs='/rootfs'", 
          "--collector.filesystem.ignored-mount-points='^/(sys|proc|dev|host|etc)($|/)'"
        ]
        #shm_size = 134217728

        volumes = [
          # Use absolute paths to mount arbitrary paths on the host
          #"/proc:/host/proc:ro,rslave",
          #"/sys:/host/sys:ro,rslave",
          "/:/rootfs:ro,rslave"
        ]

        #labels {
          #log-pilot log collector
          #aliyun.logs.catalina = "stdout"
          #aliyun.logs.access = "/usr/local/tomcat/logs/localhost_access_log*.txt"
        #}

      }

      service {
        name = "node-exporter"
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
          port "metrics" {
             static = 9100
          }
        }
      }
    }
  }
}
