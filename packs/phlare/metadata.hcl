app {
  url = "https://grafana.com/oss/phlare/"
}

pack {
  name        = "phlare"
  description = "Grafana Phlare is an open source database that provides fast, scalable, highly available, and efficient storage and querying of profiling data"
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
