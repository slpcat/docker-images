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

      vault {
        policies = ["default", "rabbit"]
        change_mode = "restart"
      }

      config {
        image = "pondidum/rabbitmq:consul"
        hostname = "${attr.unique.hostname}"
        port_map {
          amqp = 5671
          ui = 15671
          discovery = 4369
          clustering = 25672
        }
        volumes = [
          "/vagrant/vault/mshome.crt:/etc/ssl/certs/mshome.crt",
          "secrets/rabbit.pem:/etc/ssl/certs/rabbit.pem",
          "secrets/rabbit.pem:/tmp/rabbitmq-ssl/combined.pem"
        ]
      }

      env {
        RABBITMQ_SSL_VERIFY = "verify_peer"
        RABBITMQ_SSL_FAIL_IF_NO_PEER_CERT = "false"
        RABBITMQ_SSL_CACERTFILE = "/etc/ssl/certs/mshome.crt"
        RABBITMQ_SSL_CERTFILE = "/etc/ssl/certs/rabbit.pem"
        RABBITMQ_SSL_KEYFILE = "/etc/ssl/certs/rabbit.pem"

        CONSUL_HOST = "${attr.unique.network.ip-address}"
        CONSUL_SVC_PORT = "${NOMAD_HOST_PORT_amqp}"
        CONSUL_SVC_TAGS = "amqp"
      }

      template {
        data = <<EOH
{{ $host := printf "common_name=%s.mshome.net" (env "attr.unique.hostname") }} {{ with secret "pki/issue/rabbit" $host "format=pem" }}
{{ .Data.certificate }}
{{ .Data.private_key }}{{ end }}
      EOH
        destination   = "secrets/rabbit.pem"
        change_mode   = "restart"
      }

      template {
        data = <<EOH
        {{ with secret "secret/data/rabbit/cookie" }}
        RABBITMQ_ERLANG_COOKIE="{{ .Data.data.cookie }}"
        {{ end }}
        {{ with secret "secret/data/rabbit/admin" }}
        RABBITMQ_DEFAULT_USER={{ .Data.data.username }}
        RABBITMQ_DEFAULT_PASS={{ .Data.data.password }}
        {{ end }}
        EOH
        destination = "secrets/rabbit.env"
        env = true
      }

      resources {
        network {
          port "amqp" {}
          port "ui" { static = 443 }
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
