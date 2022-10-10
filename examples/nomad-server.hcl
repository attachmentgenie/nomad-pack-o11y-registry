datacenter = "lab"
data_dir = "/var/lib/nomad"
bind_addr = "0.0.0.0"
advertise {
  http = "192.168.1.10:4646"
  rpc  = "192.168.1.10:4647"
  serf = "192.168.1.10:4648"
}
consul {
}
server {
  bootstrap_expect = 1
  default_scheduler_config {
    scheduler_algorithm = "spread"

    memory_oversubscription_enabled = true

    preemption_config {
      batch_scheduler_enabled    = true
      system_scheduler_enabled   = true
      service_scheduler_enabled  = true
      sysbatch_scheduler_enabled = true # New in Nomad 1.2
    }
  }
  enabled = true
}
telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}
ui {
  enabled =  true
  consul {
    ui_url = "http://consul.teambla.dev/ui"
  }
  vault {
    ui_url = "http://vault.teambla.dev/ui"
  }
}
vault {
  enabled     = true
  address     = "http://vault.service.consul:8200"
}