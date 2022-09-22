datacenters = [
  "lab",
]
consul_service_tags = [
  "traefik.enable=true",
  "metrics"
]
tempo_upstreams = [{
  name = "s3",
  port = 9000
}]
tempo_yaml = <<EOF
server:
  http_listen_port: 3200
distributor:
  receivers:
    jaeger:
      protocols:
        thrift_http:
        grpc:
        thrift_binary:
        thrift_compact:
    zipkin:
    otlp:
      protocols:
        http:
        grpc:
    opencensus:
ingester:
  trace_idle_period: 10s
  max_block_bytes: 1_000_000
  max_block_duration: 5m
compactor:
  compaction:
    compaction_window: 1h
    max_block_bytes: 100_000_000
    block_retention: 1h
    compacted_block_retention: 10m
storage:
  trace:
    backend: s3
    block:
      bloom_filter_false_positive: .05
      index_downsample_bytes: 1000
      encoding: zstd
    wal:
      path: /tmp/tempo/wal
      encoding: snappy
    local:
      path: /tmp/tempo/blocks
    s3:
      bucket: traces
      endpoint: 192.168.1.11:21062
      access_key: minioadmin
      secret_key: minioadmin
      insecure: true
    pool:
      max_workers: 100
      queue_depth: 10000
EOF