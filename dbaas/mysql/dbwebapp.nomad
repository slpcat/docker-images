job "dbwebapp" {
  datacenters = ["dc1"]
  type        = "service"

  group "dbwebapp" {
    count = 2

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "dbwebapp" {
      driver = "docker"

      env {
        DBUSER = "dbwebapp"
        DBPASS = "dbwebapp"
      }

      template {
        data = <<EOH
DBHOST="{{ range service "mysql-server" }}{{ .Address }}{{ end }}"
DBPORT="{{ range service "mysql-server" }}{{ .Port }}{{ end }}"
EOH

        destination = "mysql-server.env"
        env         = true
      }

      config {
        image = "neumayer/dbwebapp"

        port_map {
          web = 8080
        }
      }

      resources {
        cpu    = 50
        memory = 32

        network {
          mbits = 1
          port  "web" {}
        }
      }

      service {
        name = "dbwebapp"
        port = "web"

        check {
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}

