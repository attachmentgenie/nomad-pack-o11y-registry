job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "tempo" {
    network {
      [[ if var "register_service" . ]]
      [[  $service_provider := var "service_provider" . ]]
      [[ if eq $service_provider "consul" ]]
      mode = "bridge"
      [[ end ]]
      [[ end ]]
      port "gossip" {
        to = 7946
      }
      port "grpc" {
        to = 9095
      }
      port "http" {
        to = 3200
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
    
    [[ template "volume" . ]]

    [[ if var "register_service" . ]]
    service {
      name     = "[[ var "service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      [[ range $tag := var "service_tags" . ]]
      tags     = [[ var "service_tags" . | toStringList ]]
      [[ end ]]
      port     = "http"
      check {
        type     = "http"
        path     = "/ready"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if var "service_connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 3200
            [[ range $upstream := var "service_upstreams" . ]]
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
      name     = "[[ var "service_name" . ]]-gossip"
      provider = "[[ var "service_provider" . ]]"
      port     = "gossip"
    }
    service {
      name     = "[[ var "service_name" . ]]-grpc"
      provider = "[[ var "service_provider" . ]]"
      port     = "grpc"
    }
    service {
      name     = "[[ var "service_name" . ]]-otlp-grpc"
      provider = "[[ var "service_provider" . ]]"
      port     = "otlp_grpc"
      [[ if var "service_connect_enabled" . ]]
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
      name     = "[[ var "service_name" . ]]-otlp-http"
      provider = "[[ var "service_provider" . ]]"
      port     = "otlp_http"
    }
    service {
      name     = "[[ var "service_name" . ]]-zipkin"
      provider = "[[ var "service_provider" . ]]"
      port     = "zipkin"
    }
    [[ end ]]

    task "tempo" {
      driver = "docker"

      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = [[ var "volume_name" . | quote ]]
        destination = "/tempo"
        read_only   = false
      }
      [[- end ]]
      
      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        ports = ["gossip","grpc","http"]
        [[- if var "config_yaml" . ]]
        args = [
          "--config.file=/etc/tempo/config/tempo.yml",
        ]
        volumes = [
          "local/config:/etc/tempo/config",
        ]
        [[- end ]]
      }

      [[ template "resources" . ]]

      [[- if var "config_yaml" . ]]
      template {
        data = <<EOH
[[ var "config_yaml" . ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/tempo.yml"
      }
[[- end ]]
    }
  }
}
