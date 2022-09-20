job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "graphite_exporter" {
    count = [[ .my.count ]]

    network {
      mode = "bridge"
      port "endpoint" {
        to = 9108
      }
      port "graphite" {
        to = 9109
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
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if .my.register_consul_service ]]
      connect {
        sidecar_service {}
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

    task "exporter" {
      driver = "[[ .my.prometheus_graphite_exporter_task.driver ]]"

      config {
        image = "prom/graphite-exporter:[[ .my.prometheus_graphite_exporter_task.version ]]"
        ports = ["endpoint","graphite"]
      }
    }
  }
}
