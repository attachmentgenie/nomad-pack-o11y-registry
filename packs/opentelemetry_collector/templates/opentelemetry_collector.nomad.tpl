job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "otel-collector" {
    [[ if var "register_service" . ]]
    [[- if var "task_services" . ]]
    [[ range $idx, $service := var "task_services" . ]]
    service {
      name     = [[ $service.service_name | quote ]]
      port     = [[ $service.service_port_label | quote ]]
      provider = [[ $service.service_provider | quote ]]
      tags     = [[ $service.service_tags | toStringList ]]
      [[- if $service.check_enabled ]]
      check {
        type     = "http"
        path     = [[ $service.check_path | quote ]]
        interval = [[ $service.check_interval | quote ]]
        timeout  = [[ $service.check_timeout | quote ]]
      }
      [[- end ]]
      [[- if $service.connect_enabled ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = [[ $service.service_port ]]
            [[ range $upstream := $service.connect_upstreams ]]
            upstreams {
              destination_name = [[ $upstream.name | quote ]]
              local_bind_port  = [[ $upstream.port ]]
            }
            [[ end ]]
          }
        }
      }
      [[- end ]]
    }
    [[- end ]]
    [[- end ]]
    [[- end ]]

    network {
      [[ if var "register_service" . ]]
      [[  $service_provider := var "service_provider" . ]]
      [[ if eq $service_provider "consul" ]]
      mode = "bridge"
      [[ end ]]
      [[ end ]]
      [[ range $idx, $service := var "task_services" . ]]
      port [[ $service.service_port_label | quote ]] {
        to = [[ $service.service_port ]]
      }
      [[- end ]]
    }

    task "otel-collector" {
      driver = "docker"

      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        entrypoint = [
          "/otelcol-contrib",
          "--config=[[ var "config_yaml_location" . ]]"
        ]

        [[- if var "privileged_mode" . ]]
        pid_mode   = "host"
        privileged = true
        [[- end ]]

        [[- $network_config:= var "network_config" . ]]
        ports = [[ keys $network_config.ports | toPrettyJson ]]

        volumes = [
          "[[ var "config_yaml_location" . ]]:/etc/otel/config.yaml",
          [[- if var "privileged_mode" . ]]
          "/:/hostfs:ro,rslave",
          [[- end ]]
        ]

      }

      [[ template "env_vars" . ]]

      template {
        data = <<EOH
[[ var "otel_config_yaml" . ]]
EOH

        change_mode   = "restart"
        destination   = "[[ var "config_yaml_location" . ]]"
      }

      [[ template "additional_templates" . ]]

      [[ template "resources" . ]]
    }
  }
}
