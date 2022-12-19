consul_service_tags = [
  "traefik.enable=true",
  "metrics"
]
count = 2
loki_upstreams = [{
  name = "s3",
  port = 9000
}]
loki_yaml = <<EOF
auth_enabled: false
server:
  http_listen_port: 3100
memberlist:
  join_members:
    - dnssrv+_loki-gossip._tcp.service.consul
schema_config:
  configs:
    - from: 2021-08-01
      store: boltdb-shipper
      object_store: s3
      schema: v11
      index:
        prefix: index_
        period: 24h
common:
  path_prefix: /loki
  replication_factor: 1
  storage:
    s3:
      endpoint: localhost:9000
      insecure: true
      bucketnames: logs
      access_key_id: minioadmin
      secret_access_key: minioadmin
      s3forcepathstyle: true
  ring:
    kvstore:
      store: memberlist
ruler:
  storage:
    s3:
      bucketnames: loki-rules
EOF
version_tag = "2.7.1"