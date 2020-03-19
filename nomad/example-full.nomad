job "redis-cache" {
  region = "global"
  datacenters = ["dc1"]
  type = "service"

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }

  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }

  group "cache" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    ephemeral_disk {
      sticky = true
      migrate = true
      size = 300
    }


    #affinity {
       # attribute specifies the name of a node attribute or metadata
       # attribute = "${node.datacenter}"

       # value specifies the desired attribute value. In this example Nomad
       # will prefer placement in the "us-west1" datacenter.
       # value  = "us-west1"

       # weight can be used to indicate relative preference
       # when the job has more than one affinity. It defaults to 50 if not set.
       # weight = 100
    #  }

    # spread {
       # attribute specifies the name of a node attribute or metadata
       # attribute = "${node.datacenter}"
    
       # targets can be used to define desired percentages of allocations
       # for each targeted attribute value.
       #
       #   target "us-east1" {
       #     percent = 60
       #   }
       #   target "us-west1" {
       #     percent = 40
       #   }
    #  }

    task "redis" {
      driver = "docker"
      config {
        network_mode = "bridge"
        image = "redis:5.0"
        #auth {
          #username = "dockerhub_user"
          #password = "dockerhub_password"
          #server_address = "hub.docker.com"
        #}
        args = [
          "-bind", "${NOMAD_PORT_http}",
          "${nomad.datacenter}",
          "${MY_ENV}",
          "${meta.foo}",
        ]
        port_map {
          db = 6379
        }
        storage_opt = {
          size = "10G"
        }
        #volumes = [
          # Use absolute paths to mount arbitrary paths on the host
          #"/path/on/host:/path/in/container"
        #]
        #volume_driver = "pxd"

        sysctl {
          net.core.somaxconn = "16384"
        }

        labels {
          foo = "bar"
          zip = "zap"
        }
      }

      # artifact {
      #   source = "http://foo.com/artifact.tar.gz"
      #   options {
      #     checksum = "md5:c4aa853ad2215426eb7d70a21922e794"
      #   }
      # }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
        network {
          mbits = 10
          port "db" {}
        }
      }

      service {
        name = "redis-cache"
        tags = ["global", "cache"]
        port = "db"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      # template {
      #   data          = "---\nkey: {{ key \"service/my-key\" }}"
      #   destination   = "local/file.yml"
      #   change_mode   = "signal"
      #   change_signal = "SIGHUP"
      # }

      # vault {
      #   policies      = ["cdn", "frontend"]
      #   change_mode   = "signal"
      #   change_signal = "SIGHUP"
      # }

      kill_timeout = "20s"
    }
  }
