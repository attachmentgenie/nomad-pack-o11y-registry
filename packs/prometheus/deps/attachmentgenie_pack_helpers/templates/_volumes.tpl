// Generic volumes template
[[ define "volume" -]]
    [[ if var "volume_name" . ]]
    volume "[[ var "volume_name" . ]]" {
      type      = "[[ var "volume_type" . ]]"
      read_only = false
      source    = "[[ var "volume_name" . ]]"
    }
    [[- end ]]
[[- end ]]
