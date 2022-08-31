job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "grafana_agent" {
    count = [[ .my.count ]]

    network {
      port "http" {
        to = 12345
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
        path     = "/-/healthy"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[ end ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "agent" {
      driver = "docker"

      config {
        image = "grafana/agent:[[ .my.grafana_agent_task.version ]]"
        args = [[ .my.grafana_agent_task.cli_args | toPrettyJson ]]
        ports = ["http"]
        volumes = [
          "local/config:/etc/grafana_agent",
        ]
      }

      [[- if ne .my.grafana_agent_task_app_grafana_agent_yaml "" ]]
      template {
        data = <<EOH
[[ .my.grafana_agent_task_app_grafana_agent_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/grafana_agent.yml"
      }
      [[- end ]]
    }
  }
}
