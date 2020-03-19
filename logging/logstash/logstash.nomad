job "logstash" {
  #region = "alicloud-beijing"
  datacenters = ["dc1", "zone-f"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  #constraint {
  #  attribute = "${meta.department}"
  #  value     = "research-center"
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
  #  value     = "1.2.3.4"
  #}

  #Nomad provides the service, system and batch schedulers.
  type = "service"

  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = true
    canary            = 0
    stagger           = "30s"
  }

  group "logstash" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    #ephemeral_disk {
    #  driver = "zfs"
    #  attributes {
    #  record_size = 16
    #  #more file system attributes
    #  }
    #}

    task "logstash" {
      #artifact {
      #  source      = "https://example.com/file.tar.gz"
      #  destination = "local/some-directory"
      #  options {
      #    checksum = "md5:df6a4178aec9fbdc1d6d7e3634d1bc33"
      #  }
      #}

      driver = "docker"

      env {
            ## Logstash monitoring API host and port env vars
            HTTP_HOST = "0.0.0.0"
            HTTP_PORT = "9600"
            ## Elasticsearch output
            ELASTICSEARCH_HOST = "elasticsearch-client"
            ELASTICSEARCH_PORT = "9200"
            ## Additional env vars
            CONFIG_RELOAD_AUTOMATIC = "true"
            #PATH_CONFIG = "/usr/share/logstash/pipeline"
            PATH_DATA = "/usr/share/logstash/data"
            QUEUE_CHECKPOINT_WRITES = "1"
            QUEUE_DRAIN = "true"
            QUEUE_MAX_BYTES = "1gb"
            QUEUE_TYPE = "persisted"
      }

      template {
        data = <<EOH
        input {
          # udp {
          #   port => 1514
          #   type => syslog
          # }
          # tcp {
          #   port => 1514
          #   type => syslog
          # }
          beats {
            port => 5044
          }
          # http {
          #   port => 8080
          # }
          # kafka {
          #   ## ref: https://www.elastic.co/guide/en/logstash/current/plugins-inputs-kafka.html
          #   bootstrap_servers => "kafka-input:9092"
          #   codec => json { charset => "UTF-8" }
          #   consumer_threads => 4
          #   topics => ["source"]
          #   topics_pattern  => "elk-.*"
          #   type => "example"
          #   decorate_events => true
          #   auto_offset_reset => "latest"
          #   group_id => "logstash1"##logstash 集群需相同
          # }
        }
        filter {
          #定义数据的格式
          grok {
          match => { "message" => "%{DATA:timestamp}\|%{IP:serverIp}\|%{IP:clientIp}\|%{DATA:logSource}\|%{DATA:userId}\|%{DATA:reqUrl}\|%{DATA:reqUri}\|%{DATA:refer}\|%{DATA:device}\|%{DATA:textDuring}\|%{DATA:duringTime:int}\|\|"}
          }
          date {
            match => [ "timestamp", "yyyy-MM-dd-HH:mm:ss" ]
            locale => "cn"
          }
          #定义客户端的IP是哪个字段（上面定义的数据格式）
          geoip {
          source => "clientIp"
          }
          #定义客户端设备是哪一个字段
          useragent {
            source => "device"
            target => "userDevice"
          }
          #需要进行转换的字段，这里是将访问的时间转成int，再传给Elasticsearch
          mutate {
            convert => ["duringTime", "integer"]
          }
        }
        output {
          # stdout { codec => rubydebug }
          elasticsearch {
            hosts => ["${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}"]
            manage_template => true
            index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
            document_type => "%{[@metadata][type]}"
          }
          # kafka {
          #   ## ref: https://www.elastic.co/guide/en/logstash/current/plugins-outputs-kafka.html
          #   bootstrap_servers => "kafka-output:9092"
          #   codec => json { charset => "UTF-8" }
          #   compression_type => "lz4"
          #   topic_id => "destination"
          # }
        }
        EOH

        destination = "local/logstash.conf"
      }

      logs{
        max_files=5
        max_file_size=20
      }

      config {
        image = "docker.elastic.co/logstash/logstash-oss:6.6.1"
        force_pull = false
        #network_mode = "host"
        #command = "my-command"
        #args = [
        #  "-bind", "${NOMAD_PORT_http}",
        #  "${nomad.datacenter}",
        #  "${MY_ENV}",
        #  "${meta.foo}",
        #]
        #shm_size = 134217728

        volumes = [
          # Use absolute paths to mount arbitrary paths on the host
          "/data/logstash:/usr/share/logstash/data",
          #patterns:/usr/share/logstash/patterns
          #pipeline:/usr/share/logstash/pipeline
          "local/logstash.conf:/usr/share/logstash/pipeline/logstash.conf"
        ]

        sysctl {
          net.ipv4.tcp_syncookies = "0"
          net.ipv4.ip_local_port_range = "1024 65535"
          net.core.somaxconn = "65535"
          net.ipv4.ip_unprivileged_port_start = "0"
          net.ipv4.tcp_tw_reuse = "2"
          net.ipv4.tcp_fin_timeout = "20"
          net.ipv4.tcp_keepalive_intvl = "10"
          net.ipv4.tcp_keepalive_probes = "2"
          net.ipv4.tcp_keepalive_time = "120"
          net.ipv4.tcp_ecn = "1"
          net.ipv4.tcp_max_syn_backlog = "65536"
          net.ipv4.tcp_rfc1337 = "1"
          net.ipv4.tcp_slow_start_after_idle = "0"
          net.ipv4.tcp_fack = "1"
          net.ipv4.tcp_max_tw_buckets = "1048576"
          net.ipv4.tcp_fastopen = "3"
          net.ipv4.icmp_ratelimit = "100"
          net.ipv4.tcp_abort_on_overflow = "1"
          net.ipv4.tcp_adv_win_scale = "2"
          net.ipv4.tcp_retries2 = "8"
          net.ipv4.tcp_syn_retries = "3"
          net.ipv4.tcp_synack_retries = "2"
          net.unix.max_dgram_qlen = "512"
          net.ipv4.tcp_fwmark_accept = "1"
          net.ipv4.fwmark_reflect = "1"
        }

        #labels {
          #log-pilot log collector
          #aliyun.logs.catalina = "stdout"
          #aliyun.logs.access = "/usr/local/tomcat/logs/localhost_access_log*.txt"
        #}

        port_map {
          beats = 5044
          monitor = 9600
        }
      }

      service {
        name = "logstash"
        port = "beats"
        port = "monitor"
        tags = [
          "online"
          ]

        check {
          name = "checks"
          type = "tcp"
          interval = "10s"
          timeout = "5s"
        }
      }

      kill_timeout = "20s"
      resources {
        cpu = 500
        memory = 1024
        network {
          mbits = 10
          port "beats" {
            #static = 15044
          }
          port "monitor" {
            #static = 19600
          }
        }
      }
    }
  }
}
