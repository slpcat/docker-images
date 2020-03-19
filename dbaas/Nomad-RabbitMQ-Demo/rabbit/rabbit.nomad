job "rabbit" {

  datacenters = ["dc1"]
  type = "service"

  group "cluster" {
    count = 3

    update {
      max_parallel = 1
    }

    migrate {
      max_parallel = 1
      health_check = "checks"
      min_healthy_time = "5s"
      healthy_deadline = "30s"
    }

    task "rabbit" {
      driver = "docker"

      config {
        image = "pondidum/rabbitmq:consul"
        hostname = "${attr.unique.hostname}"
        port_map {
          amqp = 5672
          ui = 15672
          discovery = 4369
          clustering = 25672
        }
      }

      env {
        RABBITMQ_ERLANG_COOKIE = "rabbitmq"
        RABBITMQ_DEFAULT_USER = "administrator"
        RABBITMQ_DEFAULT_PASS = "some secure password here"

        CONSUL_HOST = "${attr.unique.network.ip-address}"
        CONSUL_SVC_PORT = "${NOMAD_HOST_PORT_amqp}"
        CONSUL_SVC_TAGS = "amqp"
      }

      resources {
        network {
          port "amqp" {}
          port "ui" {}
          port "discovery" { static = 4369 }
          port "clustering" { static = 25672 }
        }
      }

      service {
        name = "rabbitmq"
        port = "ui"
        tags = ["management", "http"]
      }

    }
  }
}
