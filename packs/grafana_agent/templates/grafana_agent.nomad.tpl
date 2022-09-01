job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "system"

  group "grafana_agent" {
    count = [[ .my.count ]]

    network {
      port "endpoint" {
        to = 12345
      }
    }

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "agent" {
      driver = "[[ .my.grafana_agent_task.driver ]]"

      config {
        image = "grafana/agent:[[ .my.grafana_agent_task.version ]]"
        args = [[ .my.grafana_agent_task.cli_args | toPrettyJson ]]
        ports = ["endpoint"]
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
