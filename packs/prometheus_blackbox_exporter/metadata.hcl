app {
  url = "https://prometheus.io/"
}

pack {
  name        = "prometheus_blackbox_exporter"
  description = "Prometheus is used to collect telemetry data and make it queryable."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "c9bf50a9"
}
