consul_service_tags = [
  "traefik.enable=true",
  "metrics"
]
datacenters = [
  "lab",
]
mimir_task_app_mimir_yaml = <<EOF
common:
  storage:
    backend: s3
    s3:
      endpoint: endpoint: {{ range $i, $s := service "s3" }}{{ if eq $i 0 }}{{.Address}}:{{.Port}}{{end}}{{end}}
      access_key_id: minioadmin
      secret_access_key: minioadmin
      insecure: true
      bucket_name: metrics
blocks_storage:
  backend: s3
  bucket_store:
    sync_dir: /tmp/mimir/tsdb-sync
  tsdb:
    dir: /tmp/mimir/tsdb
compactor:
  data_dir: /tmp/mimir/compactor
  sharding_ring:
    kvstore:
      store: memberlist
distributor:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: memberlist
ingester:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: memberlist
    replication_factor: 1
ruler_storage:
  backend: s3
  s3:
    bucket_name: rules
server:
  log_level: error
store_gateway:
  sharding_ring:
    replication_factor: 1
EOF
mimir_upstreams = [{
  name = "s3",
  port = 9000,
}]
mimir_task = {
  driver   = "docker",
  version  = "2.3.1",
  cli_args = [
    "--config.file=/etc/mimir/mimir.yml",
  ]
}