job "ingress-traefik" {
  #region = "alicloud-beijing"
  datacenters = ["dc1", "zone-f"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  #constraint {
  #  attribute = "${meta.department}"
  #  value     = "sale-group"
  #}

  #constraint {
  #  attribute = "${meta.storage}"
  #  value     = "ssd"
  #}

  #constraint {
  #  attribute = "${meta.rack}"
  #  value     = "B001"
  #}

  #constraint {
  #  attribute = "${attr.unique.network.ip-address}"
  #  value     = "172.16.1.1"
  #}

  type = "system"

  group "ingress-traefik" {
    task "ingress-traefik" {
      driver = "docker"

      logs{
        max_files=5
        max_file_size=20
      }

      config {
        image = "traefik:v1.7-alpine"
        args  = [
          "--api",
          "--metrics",
          "--metrics.prometheus",
          "--logLevel=INFO",
          "--consulcatalog.endpoint=localhost:8500",
          "--consulcatalog.exposedByDefault=false",
          "--consulcatalog.stale=true",
          "--consulcatalog.domain=consul.localhost"
        ]

        network_mode = "host"
        #labels {
          #log-pilot log collector
          #aliyun.logs.catalina = "stdout"
          #aliyun.logs.access = "/usr/local/tomcat/logs/localhost_access_log*.txt"
        #}
      }

      kill_timeout = "20s"

      resources {
        cpu    = 500
        memory = 1024
        network {
          mbits = 20
          port "proxy" {
            static = 80
          }
          port "ui" {
            static = 8080
          }
        }
      }
    }
  }
}
