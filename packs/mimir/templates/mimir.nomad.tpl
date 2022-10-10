job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "mimir" {
    count = [[ .my.count ]]

    network {
      mode = "bridge"
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
      [[ if .my.register_consul_service ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            [[ range $upstream := .my.mimir_upstreams ]]
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

    task "server" {
      driver = "[[ .my.mimir_task.driver ]]"

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
