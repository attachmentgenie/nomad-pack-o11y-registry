consul_service_name = "graphite-exprtr"
consul_service_tags = ["metrics"]
prometheus_graphite_exporter_task = {
  driver   = "docker",
  version  = "v0.12.3",
}
