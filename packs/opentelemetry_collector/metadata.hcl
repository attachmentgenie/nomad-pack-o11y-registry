app {
  url = "https://github.com/open-telemetry/opentelemetry-collector"
}

pack {
  name        = "opentelemetry_collector"
  description = "The OpenTelemetry Collector offers a vendor-agnostic implementation on how to receive, process and export telemetry data."
  version     = "0.2.0"
}

dependency "attachmentgenie_pack_helpers" {
  alias  = "attachmentgenie_pack_helpers"
  source = "git::https://github.com/attachmentgenie/nomad-pack-attachmentgenie-registry.git//packs/attachmentgenie_pack_helpers"
  ref    = "79b6a981"
}
