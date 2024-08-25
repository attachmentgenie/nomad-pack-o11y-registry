job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "prometheus" {
    network {
      [[ if var "register_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "http" {
        to = 9090
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
        path     = "/-/healthy"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if var "service_connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 9090
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
    [[ end ]]

    task "prometheus" {
      driver = "docker"

      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = [[ var "volume_name" . | quote ]]
        destination = "/prometheus"
        read_only   = false
      }
      [[- end ]]

      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        ports   = ["http"]
        args = [[ var "prometheus_cli_args" . | toPrettyJson ]]
        volumes = [
          "local/config:/etc/prometheus/config",
        ]
      }

      [[ template "prometheus_yaml_template" . ]]
      [[ template "rules_yaml_template" . ]]

      [[ template "resources" . ]]
    }
  }
}
