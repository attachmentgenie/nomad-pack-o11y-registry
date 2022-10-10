datacenter = "lab"
data_dir = "/var/lib/nomad/data"
bind_addr = "0.0.0.0"
client {
  enabled = true
  host_volume "minio" {
    path      = "/opt/nomad/minio"
    read_only = false
  }
}
consul {
}
plugin "docker" {
  config {
    allow_privileged = true
  }
}
telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}
vault {
  enabled     = true
  address     = "http://vault.service.consul:8200"
}