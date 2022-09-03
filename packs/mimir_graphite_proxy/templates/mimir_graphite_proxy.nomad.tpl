job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "app" {
    count = [[ .my.count ]]

    network {
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
