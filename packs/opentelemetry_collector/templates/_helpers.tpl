// the default map configures the hostmetrics receiver to look at `/hostfs` mounts for system stats
// it is merged with .task_config.env which will take precedence in the merge
// in the event of a conflict
[[- define "env_vars" -]]
[[- $defaultEnv := (dict
  "HOST_PROC" "/hostfs/proc"
  "HOST_SYS" "/hostfs/sys"
  "HOST_ETC" "/hostfs/etc"
  "HOST_VAR" "/hostfs/var"
  "HOST_RUN" "/hostfs/run"
  "HOST_DEV" "/hostfs/dev"
) -]]
    env {
      [[- $task_envs:= var "env_vars" . ]]
      [[- range $key, $value := mergeOverwrite $defaultEnv $task_envs -]]
      [[- if $key ]]
        [[ $key ]] = [[ $value | quote ]]
      [[- end ]]
      [[- end ]]
    }
[[- end -]]

// render any additional templates for the task
[[- define "additional_templates" -]]
  [[- range $tmpl := var "additional_templates" . ]]
      template {
        destination = [[ $tmpl.destination | quote ]]
        data = <<EOH
[[ $tmpl.data -]]
EOH
        [[- if $tmpl.change_mode ]]
        change_mode = [[ $tmpl.change_mode | quote ]]
        [[- end ]]
        [[- if $tmpl.change_signal ]]
        change_signal = [[ $tmpl.change_signal | quote ]]
        [[- end ]]
        [[- if $tmpl.env ]]
        env = [[ $tmpl.env ]]
        [[- end ]]
        [[- if $tmpl.perms ]]
        perms = [[ $tmpl.perms | quote ]]
        [[- end ]]
      }
  [[- end ]]
[[- end ]]
