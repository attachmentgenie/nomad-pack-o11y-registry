job [[ template "full_job_name" . ]] {

  region      = [[ .prometheus.region | quote ]]
  datacenters = [[ .prometheus.datacenters | toStringList ]]
  namespace   = [[ .prometheus.namespace | quote ]]
  [[ if .prometheus.constraints ]][[ range $idx, $constraint := .prometheus.constraints ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    value     = [[ $constraint.value | quote ]]
    [[- if ne $constraint.operator "" ]]
    operator  = [[ $constraint.operator | quote ]]
    [[- end ]]
  }
  [[- end ]][[- end ]]

  group "prometheus" {
    [[- if .my.prometheus_volume ]]
    volume "prometheus" {
      type = [[ .my.prometheus_volume.type | quote ]]
      read_only = false
      source = [[ .my.prometheus_volume.source | quote ]]
    }
    [[- end ]]

    [[- if .prometheus.prometheus_task_services ]]
    [[- range $idx, $service := .prometheus.prometheus_task_services ]]
    service {
      name = [[ $service.service_name | quote ]]
      port = [[ $service.service_port_label | quote ]]
      tags = [[ $service.service_tags | toStringList ]]

      check {
        type     = "http"
        path     = [[ $service.check_path | quote ]]
        interval = [[ $service.check_interval | quote ]]
        timeout  = [[ $service.check_timeout | quote ]]
      }
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            [[ range $upstream := $service.service_upstreams ]]
            upstreams {
              destination_name = [[ $upstream.name | quote ]]
              local_bind_port  = [[ $upstream.port ]]
            }
            [[ end ]]
          }
        }
      }
    }
    [[- end ]]
    [[- end ]]

    network {
      mode = [[ .prometheus.prometheus_group_network.mode | quote ]]
      [[- range $label, $to := .prometheus.prometheus_group_network.ports ]]
      port [[ $label | quote ]] {
        to = [[ $to ]]
      }
      [[- end ]]
    }

    task "prometheus" {
      driver = "[[ .prometheus.prometheus_task.driver ]]"

      [[- if .my.prometheus_volume ]]
      volume_mount {
        volume      = [[ .my.prometheus_volume.name | quote ]]
        destination = "/prometheus"
        read_only   = false
      }
      [[- end ]]

      config {
        image = "prom/prometheus:v[[ .prometheus.prometheus_task.version ]]"
        args = [[ .prometheus.prometheus_task.cli_args | toPrettyJson ]]
        volumes = [
          "local/config:/etc/prometheus/config",
        ]
      }

[[- if ne .prometheus.prometheus_task_app_prometheus_yaml "" ]]
      template {
        data = <<EOH
[[ .prometheus.prometheus_task_app_prometheus_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/prometheus.yml"
      }
[[- end ]]

[[- if ne .prometheus.prometheus_task_app_rules_yaml "" ]]
      template {
        data = <<EOH
[[ .prometheus.prometheus_task_app_rules_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/rules.yml"
      }
[[- end ]]

      resources {
        cpu    = [[ .prometheus.prometheus_task_resources.cpu ]]
        memory = [[ .prometheus.prometheus_task_resources.memory ]]
      }
    }
  }
}
