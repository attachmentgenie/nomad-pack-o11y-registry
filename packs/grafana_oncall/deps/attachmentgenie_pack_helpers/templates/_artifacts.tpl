[[- /*

## `artifacts` helper

*/ -]]

[[- define "artifacts" -]]
[[- if var "task_artifacts" . ]]
[[- range $artifact := var "task_artifacts" . ]]
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
[[- end ]]
