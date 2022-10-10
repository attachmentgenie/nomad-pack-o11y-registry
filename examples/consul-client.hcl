datacenter = "lab"
data_dir = "/var/lib/consul"
client_addr = "0.0.0.0"
bind_addr = "0.0.0.0" # Listen on all IPv4
advertise_addr = "192.168.1.11"
telemetry {
  prometheus_retention_time = "24h"
}
ports {
  grpc = 8502
}
connect {
  enabled = true
}
retry_join = ["192.168.1.10"]