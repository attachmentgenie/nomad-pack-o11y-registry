app {
  url = "https://grafana.com/"
}

pack {
  name        = "mimir"
  description = "Mimir is an open source, horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "c9bf50a9"
}
