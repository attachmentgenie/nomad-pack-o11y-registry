count = 2
consul_service_tags = [
  "traefik.enable=true",
  "metrics"
]
tempo_upstreams = [{
  name = "s3",
  port = 9000,
},{
  name = "mimir",
  port = 9009,
}]
tempo_yaml = <<EOF
multitenancy_enabled: false
search_enabled: true
metrics_generator_enabled: true
server:
  http_listen_port: 3200
memberlist:
  join_members:
    - dnssrv+_tempo-gossip._tcp.service.consul
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
compactor:
  ring:
    kvstore:
      store: memberlist
ingester:
  lifecycler:
    ring:
      kvstore:
        store: memberlist
metrics_generator:
  registry:
    external_labels:
      source: tempo
  storage:
    path: /tmp/tempo/generator/wal
    remote_write:
      - url: http://localhost:8080/api/v1/write
        send_exemplars: true
storage:
  trace:
    backend: s3
    s3:
      bucket: traces
      endpoint: localhost:9000
      access_key: minioadmin
      secret_key: minioadmin
      insecure: true
EOF
version_tag = "1.5.0"