// allow nomad-pack to set the job name

[[- define "job_name" -]]
[[- if eq .phlare.job_name "" -]]
[[- .nomad_pack.pack.name | quote -]]
[[- else -]]
[[- .phlare.job_name | quote -]]
[[- end -]]
[[- end -]]

// only deploys to a namespace if specified
[[- define "namespace" -]]
[[- if not (eq .my.namespace "") -]]
namespace = [[ .my.namespace | quote]]
[[- end -]]
[[- end -]]

// only deploys to a region if specified
[[- define "region" -]]
[[- if not (eq .phlare.region "") -]]
region = [[ .phlare.region | quote]]
[[- end -]]
[[- end -]]
