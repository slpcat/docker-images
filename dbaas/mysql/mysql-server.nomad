job "mysql-server" {
  datacenters = ["dc1"]
  type        = "service"

  group "mysql-server" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    ephemeral_disk {
      migrate = true
      size    = 300
      sticky  = true
    }

    task "mysql-server" {
      driver = "docker"

      config {
        image = "mysql/mysql-server:5.6"

        port_map {
          db = 3306
        }

        volumes = [
          "/data/mysql001:/var/lib/mysql",
        ]
      }
      env {
        MYSQL_ROOT_PASSWORD = "password"
        MYSQL_DATABASE = "mydb"
        MYSQL_USER = "myuser"
        MYSQL_PASSWORD = "mypassword"
        MYSQL_ALLOW_EMPTY_PASSWORD = "false"
      }

      resources {
        cpu    = 500
        memory = 2048

        network {
          mbits = 10

          port "db" {}
        }
      }

      service {
        name = "mysql-server"
        port = "db"
        tags = ["mysql", "master"]
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
