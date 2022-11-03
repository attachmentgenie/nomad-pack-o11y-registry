// allow nomad-pack to set the job name
[[ define "job_name" ]]
[[- if eq .my.job_name "" -]]
[[- .nomad_pack.pack.name | quote -]]
[[- else -]]
[[- .my.job_name | quote -]]
[[- end ]]
[[- end ]]

// only deploys to a namespace if specified
[[- define "namespace" -]]
[[- if not (eq .my.namespace "") -]]
namespace = [[ .my.namespace | quote]]
[[- end -]]
[[- end -]]

// only deploys to a region if specified
[[ define "region" -]]
[[- if not (eq .my.region "") -]]
  region = [[ .my.region | quote]]
[[- end -]]
[[- end -]]
