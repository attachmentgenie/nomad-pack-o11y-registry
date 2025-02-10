[[- define "prometheus_yaml_template" -]]
[[- if var "task_prometheus_yaml" . -]]
template {
  data = <<EOH
[[ var "task_prometheus_yaml" . ]]
EOH
  change_mode   = "signal"
  change_signal = "SIGHUP"
  destination   = "local/config/prometheus.yml"
}
[[- end ]]
[[- end ]]

[[- define "rules_yaml_template" -]]
[[- if var "task_rules_yaml" . -]]
template {
  data = <<EOH
[[ var "task_rules_yaml" . ]]
EOH
  change_mode   = "signal"
  change_signal = "SIGHUP"
  destination   = "local/config/rules.yml"
}
[[- end ]]
[[- end ]]