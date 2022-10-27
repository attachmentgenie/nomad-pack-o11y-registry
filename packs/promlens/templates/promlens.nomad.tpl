job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "server" {
    network {
      mode = "bridge"
      port "http" {
        to = 8080
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
            [[ range $upstream := .my.promlens_upstreams ]]
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

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "server" {
      driver = "[[ .my.promlens_task.driver ]]"

      config {
        image = "prom/promlens:[[ .my.promlens_task.version ]]"
        args = [[ .my.promlens_task.cli_args | toPrettyJson ]]
        ports = ["http"]
      }
    }
  }
}
