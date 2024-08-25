app {
  url = "https://grafana.com/"
}

pack {
  name        = "grafana"
  description = "Grafana is a multi-platform open source analytics and interactive visualization web application."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "79b6a981"
}
