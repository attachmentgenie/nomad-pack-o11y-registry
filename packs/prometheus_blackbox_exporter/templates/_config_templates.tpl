[[- define "blackbox_yaml_template" -]]
[[- if var "task_blackbox_yaml" . -]]
template {
  data = <<EOH
[[ var "task_blackbox_yaml" . ]]
EOH
  change_mode   = "signal"
  change_signal = "SIGHUP"
  destination   = "local/config/blackbox.yml"
}
[[- end ]]
[[- end ]]