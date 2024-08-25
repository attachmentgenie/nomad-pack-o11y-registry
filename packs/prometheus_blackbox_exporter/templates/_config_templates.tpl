[[- define "blackbox_yaml_template" -]]
[[- if var "prometheus_blackbox_exporter_task_blackbox_yaml" . -]]
template {
  data = <<EOH
[[ var "prometheus_blackbox_exporter_task_blackbox_yaml" . ]]
EOH
  change_mode   = "signal"
  change_signal = "SIGHUP"
  destination   = "local/config/blackbox.yml"
}
[[- end ]]
[[- end ]]