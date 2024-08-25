[[- /*

## `region` helper

*/ -]]

[[ define "region" -]]
[[- if var "region" . -]]
  region = "[[ var "region" . ]]"
[[- end -]]
[[- end -]]

[[- /*

## `namespace` helper

*/ -]]

[[ define "namespace" -]]
[[- if var "namespace" . -]]
  namespace = "[[ var "namespace" . ]]"
[[- end -]]
[[- end -]]

[[- /*

[[- /*

## `node_pool` helper

*/ -]]

[[ define "node_pool" -]]
[[- if var "node_pool" . -]]
  node_pool = "[[ var "node_pool" . ]]"
[[- end -]]
[[- end -]]

[[- /*

## `constraints` helper

This helper creates Nomad constraint blocks from a value of type
  `list(object(attribute string, operator string, value string))`

*/ -]]

[[ define "constraints" -]]
[[ range $idx, $constraint := var "task_constraints" . ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    [[ if $constraint.operator -]]
    operator  = [[ $constraint.operator | quote ]]
    [[ end -]]
    value     = [[ $constraint.value | quote ]]
  }
[[ end -]]
[[- end -]]

// limit where job can run
[[ define "placement" -]]
  [[ template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  [[ template "namespace" . ]]
  [[ template "node_pool" . ]]
  priority    = [[ var "priority" . ]]

  [[ template "constraints" . ]]
[[ end ]]
