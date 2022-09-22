datacenters = [
  "lab",
]
consul_service_tags = [
  "traefik.enable=true",
  "metrics"
]
loki_upstreams = [{
  name = "s3",
  port = 9000
}]
loki_yaml = <<EOF
auth_enabled: false
server:
  http_listen_port: 3100
ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s
  wal:
    dir: /loki/wal
schema_config:
  configs:
  - from: 2020-05-15
    store: boltdb
    object_store: s3
    schema: v11
    index:
      prefix: index_
      period: 168h
storage_config:
  aws:
    s3: http://minioadmin:minioadmin@192.168.1.11:21062/logs
    s3forcepathstyle: true
  boltdb:
    directory: /loki/index
  filesystem:
    directory: /loki/chunks
ruler:
  storage:
    type: local
    local:
      directory: /etc/loki/rules
  rule_path: /loki/rules
  alertmanager_url: http://localhost:9093
limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
EOF