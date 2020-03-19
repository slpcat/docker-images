job "es-cluster" {
  type        = "service"
  datacenters = ["dc1"]

  update {
    max_parallel     = 1
    health_check     = "checks"
    min_healthy_time = "180s"
    healthy_deadline = "15m"
  }

  meta {
    ES_CLUSTER_NAME = "${NOMAD_REGION}-${NOMAD_JOB_NAME}"
  }

  # master nodes has EBS backed volumes and thus can't be scaled beyond 3 nodes (1 per AZ)
  # scaling this to 3 must be done in seamstress!
  group "es-cluster-master" {
    count = 3

    # master nodes must always be spread across different AZs
    #constraint {
    #  distinct_property = "${meta.aws.instance.availability-zone}"
    #}

    # master nodes must run on high-memory-applications
    #constraint {
    #  attribute = "${node.class}"
    #  value     = "high-memory-applications"
    #}

    task "es-cluster-master" {
      driver = "docker"

      # the container will automatically drop permissions before starting elastic search
      user = "root"

      # allow elastic search 10 min to gracefully shut down
      kill_timeout = "600s"

      # use SIGTERM to shut down elastic search
      kill_signal = "SIGTERM"

      config {
        image      = "xxxxx.dkr.ecr.us-east-1.amazonaws.com/elasticsearch:6.1.3"
        command    = "elasticsearch"

        # https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-transport.html
        # https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-http.html
        args = [
          "-Ebootstrap.memory_lock=true",                          # lock all JVM memory on startup
          "-Ecloud.node.auto_attributes=true",                     # use AWS API to add additional meta data to the client (like AZ)
          "-Ecluster.name=${NOMAD_META_ES_CLUSTER_NAME}",          # name of the cluster - this must match between master and data nodes
          "-Ediscovery.zen.hosts_provider=file",                   # use a 'static' file
          "-Ediscovery.zen.minimum_master_nodes=2",                # >= 2 master nodes are required to form a healthy cluster
          "-Egateway.expected_data_nodes=3",                       # >= 3 data nodes to form a healthy cluster
          "-Egateway.expected_master_nodes=3",                     # >= 3 master nodes are the expected state of the cluster
          "-Egateway.expected_nodes=3",                            # >= 3 nodes in total are expected to be in the cluster
          "-Egateway.recover_after_nodes=3",                       # >= 3 nodes are required to start data recovery
          "-Ehttp.port=${NOMAD_PORT_rest}",                        # HTTP port (originally port 9200) to listen on inside the container
          "-Ehttp.publish_port=${NOMAD_HOST_PORT_rest}",           # HTTP port (originally port 9200) on the host instance
          "-Enetwork.host=0.0.0.0",                                # IP to listen on for all traffic
          "-Enetwork.publish_host=${NOMAD_IP_rest}",               # IP to broadcast to other elastic search nodes (this is a host IP, not container)
          "-Enode.data=true",                                      # node is allowed to store data
          "-Enode.master=true",                                    # node is allowed to be elected master
          "-Enode.name=${NOMAD_GROUP_NAME}[${NOMAD_ALLOC_INDEX}]", # node name is defauled to the allocation name
          "-Epath.logs=/alloc/logs/",                              # log data to allocation directory
          "-Etransport.publish_port=${NOMAD_HOST_PORT_transport}", # Transport port (originally port 9300) on the host instance
          "-Etransport.tcp.port=${NOMAD_PORT_transport}",          # Transport port (originally port 9300) inside the container
          "-Expack.license.self_generated.type=basic",             # use x-packs basic license (free)
        ]

        ulimit {
          # ensure elastic search can lock all memory for the JVM on start
          memlock = "-1"

          # ensure elastic search can create enough open file handles
          nofile = "65536"

          # ensure elastic search can create enough threads
          nproc = "8192"
        }

        # persistent data configuration
        volume_driver = "rexray/ebs"

        # these volumes are provisioned by infra team
        volumes = [
          "${NOMAD_REGION}-${NOMAD_JOB_NAME}-${meta.aws.instance.availability-zone}/:/usr/share/elasticsearch/data",
        ]
      }

      # consul-template writing out the unicast hosts elastic search uses to discover its cluster peers
      template {
        # this path will automatically be symlinked to the right place in the container
        destination = "/local/unicast_hosts.txt"

        # elastic search automatically reload the file on change, so no signales needed
        change_mode = "noop"

        data = <<EOF
{{- range service (printf "%s-discovery|passing" (env "NOMAD_JOB_NAME")) }}
{{ .Address }}:{{ .Port }}{{ end }}
EOF
      }

      # this consul service is used to discover unicast hosts (see above template{})
      service {
        name = "${NOMAD_JOB_NAME}-discovery"
        port = "transport"

        check {
          name     = "transport-tcp"
          port     = "transport"
          type     = "tcp"
          interval = "5s"
          timeout  = "4s"
        }
      }

      # this consul service is used for port 9200 / normal http traffic
      service {
        name = "${NOMAD_JOB_NAME}"
        port = "rest"
        tags = ["dd-elastic"]

        check {
          name     = "rest-tcp"
          port     = "rest"
          type     = "tcp"
          interval = "5s"
          timeout  = "4s"
        }

        check {
          name     = "rest-http"
          type     = "http"
          port     = "rest"
          path     = "/"
          interval = "5s"
          timeout  = "4s"
        }
      }

      resources {
        cpu    = 1024
        memory = 8192

        network {
          mbits = 25

          port "rest" {}

          port "transport" {}
        }
      }
    }
  }

  # similar to es-cluster-master, please see comments there
  group "es-cluster-data" {
    count = 0

    # data nodes must run on high-memory-applications
    constraint {
      attribute = "${node.class}"
      value     = "high-memory-applications"
    }

    # best effort to move the existing elastic search data not backed by EBS
    # the 50gig disk matches the EBS volume.
    ephemeral_disk {
      size    = "50000"
      sticky  = true
      migrate = false
    }

    task "es-cluster-data" {
      driver       = "docker"
      user         = "root"
      kill_timeout = "600s"
      kill_signal  = "SIGTERM"

      config {
        image   = "xxxxxx.dkr.ecr.us-east-1.amazonaws.com/elasticsearch:6.1.3"
        command = "elasticsearch"

        args = [
          "-Ebootstrap.memory_lock=true",
          "-Ecloud.node.auto_attributes=true",
          "-Ecluster.name=${NOMAD_META_ES_CLUSTER_NAME}",
          "-Ediscovery.zen.hosts_provider=file",
          "-Ediscovery.zen.minimum_master_nodes=2",
          "-Egateway.expected_data_nodes=3",
          "-Egateway.expected_master_nodes=3",
          "-Egateway.expected_nodes=3",
          "-Egateway.recover_after_nodes=3",
          "-Ehttp.port=${NOMAD_PORT_rest}",
          "-Ehttp.publish_port=${NOMAD_HOST_PORT_rest}",
          "-Enetwork.host=0.0.0.0",
          "-Enetwork.publish_host=${NOMAD_IP_rest}",
          "-Enode.data=true",
          "-Enode.master=false",
          "-Enode.max_local_storage_nodes=1",
          "-Enode.name=${NOMAD_ALLOC_NAME}",
          "-Epath.data=/alloc/data/",
          "-Epath.logs=/alloc/logs/",
          "-Etransport.publish_port=${NOMAD_HOST_PORT_transport}",
          "-Etransport.tcp.port=${NOMAD_PORT_transport}",
          "-Expack.license.self_generated.type=basic",
        ]

        ulimit {
          memlock = "-1"
          nofile  = "65536"
          nproc   = "8192"
        }
      }

      template {
        destination = "/local/unicast_hosts.txt"
        change_mode = "noop"

        data = <<EOF
{{- range service (printf "%s-discovery|passing" (env "NOMAD_JOB_NAME")) }}
{{ .Address }}:{{ .Port }}{{ end }}
EOF
      }

      service {
        name = "${NOMAD_JOB_NAME}"
        port = "rest"
        tags = ["dd-elastic"]

        check {
          name     = "rest-tcp"
          port     = "rest"
          type     = "tcp"
          interval = "5s"
          timeout  = "4s"
        }

        check {
          name     = "rest-http"
          type     = "http"
          port     = "rest"
          path     = "/"
          interval = "5s"
          timeout  = "4s"
        }
      }

      resources {
        cpu    = 1024
        memory = 8192

        network {
          mbits = 25

          port "rest" {}

          port "transport" {}
        }
      }
    }
  }

  group "es-cluster-kibana" {
    count = 0

    constraint {
      attribute = "${node.class}"
      value     = "applications"
    }

    update {
      max_parallel     = 1
      health_check     = "checks"
      min_healthy_time = "10s"
      healthy_deadline = "15m"
    }

    task "es-cluster-kibana" {
      driver       = "docker"
      kill_timeout = "60s"
      kill_signal  = "SIGTERM"

      config {
        image   = "docker.elastic.co/kibana/kibana:6.1.3"
        command = "kibana"

        # https://www.elastic.co/guide/en/kibana/current/settings.html
        # https://www.elastic.co/guide/en/kibana/current/settings-xpack-kb.html
        args = [
          "--elasticsearch.url=http://${NOMAD_JOB_NAME}.service.consul:80",
          "--server.host=0.0.0.0",
          "--server.name=${NOMAD_JOB_NAME}.service.consul",
          "--server.port=${NOMAD_PORT_http}",
          "--path.data=/alloc/data",
          "--elasticsearch.preserveHost=false",
          "--xpack.apm.ui.enabled=false",
          "--xpack.graph.enabled=false",
          "--xpack.ml.enabled=false",
        ]

        ulimit {
          memlock = "-1"
          nofile  = "65536"
          nproc   = "8192"
        }
      }

      service {
        name = "${NOMAD_JOB_NAME}-kibana"
        port = "http"

        check {
          name     = "http-tcp"
          port     = "http"
          type     = "tcp"
          interval = "5s"
          timeout  = "4s"
        }

        check {
          name     = "http-http"
          type     = "http"
          port     = "http"
          path     = "/"
          interval = "5s"
          timeout  = "4s"
        }
      }

      resources {
        cpu    = 1024
        memory = 2048

        network {
          mbits = 5

          port "http" {}
        }
      }
    }
  }
}
