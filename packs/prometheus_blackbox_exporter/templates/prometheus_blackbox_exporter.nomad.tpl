job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "prometheus_blackbox_exporter" {
    network {
      [[ if var "register_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "http" {
        to = 9115
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
      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if var "service_connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 9115
          }
        }
      }
      [[ end ]]
    }
    [[ end ]]

    task "prometheus_exporter" {
      driver = "docker"

      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        ports   = ["http"]
        args    = ["--config.file=/config/blackbox.yml"]
        volumes = [
          "local/config:/config",
        ]
      }

      [[ template "blackbox_yaml_template" . ]]

      [[ template "resources" . ]]
    }
  }
}
