job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters | toStringList ]]

  [[ if .my.constraints ]][[ range $idx, $constraint := .my.constraints ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    value     = [[ $constraint.value | quote ]]
    [[- if ne $constraint.operator "" ]]
    operator  = [[ $constraint.operator | quote ]]
    [[- end ]]
  }
  [[- end ]][[- end ]]

  group "tempo" {
    count = [[ .my.count ]]

    network {
      mode = "bridge"

      port "gossip" {
        to = [[ .my.gossip_port ]]
      }
      port "grpc" {
        to = [[ .my.grpc_port ]]
      }
      port "http" {
        to = [[ .my.http_port ]]
      }
      port "jaeger_thrift_compact" {
        to = 6831
      }
      port "jaeger_thrift_binary" {
        to = 6832
      }
      port "jaeger_thrift_http" {
        to = 14268
      }
      port "jaeger_grpc" {
        to = 14250
      }
      port "otlp_grpc" {
        to = 4317
      }
      port "otlp_http" {
        to = 4318
      }
      port "opencensus" {
        to = 55678
      }
      port "zipkin" {
        to = 9411
      }
    }
    
    [[- if .my.tempo_volume ]]
    volume "tempo" {
      type = [[ .my.tempo_volume.type | quote ]]
      read_only = false
      source = [[ .my.tempo_volume.source | quote ]]
    }
    [[- end ]]

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      port = "http"

      check {
        type     = "http"
        path     = "/ready"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if .my.register_consul_connect_enabled ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = [[ .my.http_port ]]
            [[ range $upstream := .my.tempo_upstreams ]]
            upstreams {
              destination_name = [[ $upstream.name | quote ]]
              local_bind_port  = [[ $upstream.port ]]
            }
            [[ end ]]
          }
        }
      }
      [[ end ]]
    }
    service {
      name = "[[ .my.consul_service_name ]]-gossip"
      port = "gossip"
    }
    service {
      name = "[[ .my.consul_service_name ]]-grpc"
      port = "grpc"
    }
    service {
      name = "[[ .my.consul_service_name ]]-otlp-grpc"
      port = "otlp_grpc"
      [[ if .my.register_consul_connect_enabled ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 4317
          }
        }
      }
      [[ end ]]
    }
    service {
      name = "[[ .my.consul_service_name ]]-otlp-http"
      port = "otlp_http"
    }
    service {
      name = "[[ .my.consul_service_name ]]-zipkin"
      port = "zipkin"
    }
    [[ end ]]

    task "tempo" {
      driver = "docker"

      [[- if .my.tempo_volume ]]
      volume_mount {
        volume      = [[ .my.tempo_volume.name | quote ]]
        destination = "/tempo"
        read_only   = false
      }
      [[- end ]]
      
      config {
        image = "grafana/tempo:[[ .my.version_tag ]]"
        ports = ["gossip","grpc","http"]
        [[- if ne .my.tempo_yaml "" ]]
        args = [
          "--config.file=/etc/tempo/config/tempo.yml",
        ]
        volumes = [
          "local/config:/etc/tempo/config",
        ]
        [[- end ]]
      }

      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }

      [[- if ne .my.tempo_yaml "" ]]
      template {
        data = <<EOH
[[ .my.tempo_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/tempo.yml"
      }
[[- end ]]
    }
  }
}
