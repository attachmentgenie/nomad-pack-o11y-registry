job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "mimir" {
    count = [[ .my.count ]]

    network {
      port "http" {
        to = 8080
      }
      port "grpc" {
        to = 9095
      }
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      port = "http"
      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[ end ]]

    task "server" {
      driver = "docker"

      config {
        image = "grafana/mimir:[[ .my.mimir_task.version ]]"
        args = [[ .my.mimir_task.cli_args | toPrettyJson ]]
        ports = ["grpc","http"]
        volumes = [
          "local/config:/etc/mimir",
        ]
      }

      [[- if ne .my.mimir_task_app_mimir_yaml "" ]]
      template {
        data = <<EOH
      [[ .my.mimir_task_app_mimir_yaml ]]
      EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/mimir.yml"
      }
      [[- end ]]
    }
  }
}
