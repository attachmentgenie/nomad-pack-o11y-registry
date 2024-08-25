app {
  url = "https://grafana.com/products/oncall/"
}

pack {
  name        = "grafana_oncall"
  description = "Grafana OnCall is an easy-to-use on-call management tool that will help reduce toil in on-call management through simpler workflows and interfaces that are tailored specifically for engineers."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "79b6a981"
}
