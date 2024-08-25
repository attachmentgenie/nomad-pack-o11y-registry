job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "grafana" {
    network {
      [[ if var "register_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "http" {
        to = 3000
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
      [[ if var "service_connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 3000
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

    task "grafana" {
      driver = "docker"

      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = [[ var "volume_name" . | quote ]]
        destination = "/var/lib/grafana"
        read_only   = false
      }
      [[- end ]]

      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        ports = ["http"]
      }

      [[ template "resources" . ]]

      [[ template "env_upper" . ]]

      [[- if var "grafana_task_artifacts" . ]]
      [[- range $artifact := var "grafana_task_artifacts" . ]]
      artifact {
        source      = [[ $artifact.source | quote ]]
        destination = [[ $artifact.destination | quote ]]
        mode = [[ $artifact.mode | quote ]]
        [[- if $artifact.options ]]
        options {
          [[- range $option, $val := $artifact.options ]]
          [[ $option ]] = [[ $val | quote ]]
          [[- end ]]
        }
        [[- end ]]

      }
      [[- end ]]
      [[- end ]]

      [[- if var "grafana_task_config_dashboards" . ]]
      template {
        data = <<EOF
[[ var "grafana_task_config_dashboards" . ]]
EOF
        destination = "/local/grafana/provisioning/dashboards/dashboards.yaml"
      }
      [[- end ]]

      [[- if var "grafana_task_config_datasources" . ]]
      template {
        data = <<EOF
[[ var "grafana_task_config_datasources" . ]]
EOF
        destination = "/local/grafana/provisioning/datasources/datasources.yaml"
      }
      [[- end ]]

      [[- if var "grafana_task_config_plugins" . ]]
      template {
        data = <<EOF
[[ var "grafana_task_config_plugins" . ]]
EOF
        destination = "/local/grafana/provisioning/plugins/plugins.yml"
      }
    [[- end ]]
    }
  }
}
