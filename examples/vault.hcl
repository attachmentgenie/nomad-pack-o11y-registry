ui = true
disable_mlock = true

storage "raft" {
  path    = "/var/lib/vault/data"
  node_id = "rpi"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

service_registration "consul" {
  address = "127.0.0.1:8500"
}

telemetry {
  prometheus_retention_time = "30s"
  disable_hostname = true
}

api_addr = "http://192.168.1.10:8200"
cluster_addr = "https://192.168.1.10:8201"