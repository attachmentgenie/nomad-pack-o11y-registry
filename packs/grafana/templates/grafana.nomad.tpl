job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "grafana" {

    network {
      [[ if var "register_service" . ]]
      [[  $service_provider := var "service_provider" . ]]
      [[ if eq $service_provider "consul" ]]
      mode = "bridge"
      [[ end ]]
      [[ end ]]
      port "http" {
        to = 3000
      }
    }

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

    [[ template "volume" . ]]

    task "grafana" {
      driver = "docker"

      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        ports = ["http"]
      }

      [[ template "artifacts" . ]]

      [[ template "env_upper" . ]]

      [[ template "resources" . ]]

      [[- if var "task_config_dashboards" . ]]
      template {
        data = <<EOF
[[ var "task_config_dashboards" . ]]
EOF
        destination = "/local/grafana/provisioning/dashboards/dashboards.yaml"
      }
      [[- end ]]

      [[- if var "task_config_datasources" . ]]
      template {
        data = <<EOF
[[ var "task_config_datasources" . ]]
EOF
        destination = "/local/grafana/provisioning/datasources/datasources.yaml"
      }
      [[- end ]]

      [[- if var "task_config_plugins" . ]]
      template {
        data = <<EOF
[[ var "task_config_plugins" . ]]
EOF
        destination = "/local/grafana/provisioning/plugins/plugins.yml"
      }
    [[- end ]]

    [[ if var "volume_name" . ]]
    volume_mount {
        volume      = [[ var "volume_name" . | quote ]]
        destination = "/var/lib/grafana"
        read_only   = false
    }
    [[- end ]]
    }
  }
}
