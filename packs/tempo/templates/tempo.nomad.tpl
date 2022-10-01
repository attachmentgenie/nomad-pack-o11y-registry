job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .tempo.datacenters | toStringList ]]

  [[ if .tempo.constraints ]][[ range $idx, $constraint := .tempo.constraints ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    value     = [[ $constraint.value | quote ]]
    [[- if ne $constraint.operator "" ]]
    operator  = [[ $constraint.operator | quote ]]
    [[- end ]]
  }
  [[- end ]][[- end ]]

  group "tempo" {
    count = 1

    network {
      mode = "bridge"

      port "grpc" {
        to = [[ .tempo.grpc_port ]]
      }
      port "http" {
        to = [[ .tempo.http_port ]]
      }
      port "jaeger_thrift_compact" {
        to = 6831
        static = 6831
      }
      port "jaeger_thrift_binary" {
        to = 6832
        static = 6832
      }
      port "jaeger_thrift_http" {
        to = 14268
        static = 14268
      }
      port "jaeger_grpc" {
        to = 14250
        static = 14250
      }
      port "otlp_grpc" {
        to = 4317
        static = 4317
      }
      port "otlp_http" {
        to = 4318
        static = 4318
      }
      port "opencensus" {
        to = 55678
        static = 55678
      }
      port "zipkin" {
        to = 9411
        static = 9411
      }
    }

    [[ if .tempo.register_consul_service ]]
    service {
      name = "[[ .tempo.consul_service_name ]]"
      tags = [[ .tempo.consul_service_tags | toStringList ]]
      port = "http"
      [[ if .tempo.register_consul_connect_enabled ]]
      connect {
        sidecar_service {
          proxy {
            [[ range $upstream := .tempo.tempo_upstreams ]]
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
    [[ end ]]

    task "tempo" {
      driver = "docker"

      config {
        image = "grafana/tempo:[[ .tempo.version_tag ]]"
        [[- if ne .tempo.tempo_yaml "" ]]
        args = [
          "--config.file=/etc/tempo/config/tempo.yml",
        ]
        volumes = [
          "local/config:/etc/tempo/config",
        ]
        [[- end ]]
      }

      resources {
        cpu    = [[ .tempo.resources.cpu ]]
        memory = [[ .tempo.resources.memory ]]
      }

      [[- if ne .tempo.tempo_yaml "" ]]
      template {
        data = <<EOH
[[ .tempo.tempo_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/tempo.yml"
      }
[[- end ]]
    }
  }
}
