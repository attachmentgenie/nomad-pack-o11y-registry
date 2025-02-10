[[- /*

## `volumes` helper

*/ -]]

[[ define "volume" -]]
    [[ if var "volume_name" . ]]
    volume "[[ var "volume_name" . ]]" {
      type      = [[ var "volume_type" . | quote ]]
      read_only = false
      source    = [[ var "volume_name" . | quote ]]
      [[- $volume_type := var "volume_type" . ]]
      [[ if eq $volume_type "csi" ]]
      access_mode     = [[ var "volume_access_mode" . | quote ]]
      attachment_mode = [[ var "volume_attachment_mode" . | quote ]]
      [[- end ]]
    }
    [[- end ]]
[[- end ]]
