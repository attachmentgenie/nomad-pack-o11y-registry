app {
  url = "https://coroot.com/"
}

pack {
  name        = "coroot"
  description = "Coroot continuously audits telemetry data to highlight issues and weak spots in your infrastructure."
  version     = "0.1.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "782df6bb"
}
