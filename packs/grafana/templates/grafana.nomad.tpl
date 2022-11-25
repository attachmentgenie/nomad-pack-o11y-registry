job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters | toStringList ]]

  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "grafana" {
    count = 1

    network {
      mode = "bridge"

    [[- if .my.dns ]]
    dns {
      [[- if .my.dns.servers ]]
        servers = [[ .my.dns.servers | toPrettyJson ]]
      [[- end ]]
      [[- if .my.dns.searches ]]
        searches = [[ .my.dns.searches | toPrettyJson ]]
      [[- end ]]
      [[- if .my.dns.options ]]
        options = [[ .my.dns.options | toPrettyJson ]]
      [[- end ]]
    }
    [[- end ]]

      port "http" {
        to = [[ .my.grafana_http_port ]]
      }
    }

    [[- if .my.grafana_volume ]]
    volume "grafana" {
      type = [[ .my.grafana_volume.type | quote ]]
      read_only = false
      source = [[ .my.grafana_volume.source | quote ]]
    }
    [[- end ]]

    service {
      name = "grafana"
      port = "http"
      tags = [[ .my.grafana_consul_tags | toStringList ]]

      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = [[ .my.grafana_http_port ]]
            [[ range $upstream := .my.grafana_upstreams ]]
            upstreams {
              destination_name = [[ $upstream.name | quote ]]
              local_bind_port  = [[ $upstream.port ]]
            }
            [[ end ]]
          }
        }
      }
    }

    task "grafana" {
      driver = "docker"

      [[- if .my.grafana_volume ]]
      volume_mount {
        volume      = [[ .my.grafana_volume.name | quote ]]
        destination = "/var/lib/grafana"
        read_only   = false
      }
      [[- end ]]

      config {
        image = "grafana/grafana:[[ .my.grafana_version_tag ]]"
        ports = ["http"]
      }

      resources {
        cpu    = [[ .my.grafana_resources.cpu ]]
        memory = [[ .my.grafana_resources.memory ]]
      }

      env {
        [[- range $var := .my.grafana_env_vars ]]
        [[ $var.key ]] = "[[ $var.value ]]"
        [[- end ]]
      }

      [[- if .my.grafana_task_artifacts ]]
        [[- range $artifact := .my.grafana_task_artifacts ]]

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

      [[- if .my.grafana_task_config_dashboards ]]
      template {
        data = <<EOF
[[ .my.grafana_task_config_dashboards ]]
EOF
        destination = "/local/grafana/provisioning/dashboards/dashboards.yaml"
      }
      [[- end ]]

      [[- if .my.grafana_task_config_datasources ]]
      template {
        data = <<EOF
[[ .my.grafana_task_config_datasources ]]
EOF
        destination = "/local/grafana/provisioning/datasources/datasources.yaml"
      }
      [[- end ]]

      [[- if .my.grafana_task_config_plugins ]]

      template {
        data = <<EOF
[[ .my.grafana_task_config_plugins ]]
EOF
        destination = "/local/grafana/provisioning/plugins/plugins.yml"
      }
    [[- end ]]
    }
  }
}
