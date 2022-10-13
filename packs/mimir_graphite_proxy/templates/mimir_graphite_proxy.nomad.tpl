job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "graphite_proxy" {
    count = [[ .my.count ]]

    network {
      mode = "bridge"
      port "health" {
        to = 8081
      }
      port "endpoint" {
        to = 8000
      }
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      port = "endpoint"
      check {
        name     = "alive"
        type     = "http"
        port     = "health"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if .my.register_consul_service ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            [[ range $upstream := .my.mimir_graphite_proxy_upstreams ]]
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
      name = "[[ .my.consul_service_name ]]-health"
      tags = [[ .my.consul_service_health_tags | toStringList ]]
      port = "health"
      check {
        name     = "alive"
        type     = "http"
        port     = "health"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if .my.register_consul_service ]]
      connect {
        sidecar_service {
          tags = [""]
        }
      }
      [[ end ]]
    }
    [[ end ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "server" {
      driver = "[[ .my.mimir_graphite_proxy_task.driver ]]"

      config {
        image = "attachmentgenie/mimir_graphite_proxy:[[ .my.mimir_graphite_proxy_task.version ]]"
        args = [[ .my.mimir_graphite_proxy_task.cli_args | toPrettyJson ]]
        ports = ["endpoint","health"]
      }
    }
  }
}
