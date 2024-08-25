app {
  url = "https://grafana.com/oss/loki/"
}

pack {
  name        = "loki"
  description = "Loki is a horizontally-scalable, highly-available, multi-tenant log aggregation system inspired by Prometheus."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "79b6a981"
}
