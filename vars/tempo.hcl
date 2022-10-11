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
multitenancy_enabled: false
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
storage:
  trace:
    backend: s3
    s3:
      bucket: traces
      endpoint: {{ range $i, $s := service "s3" }}{{ if eq $i 0 }}{{.Address}}:{{.Port}}{{end}}{{end}}
      access_key: minioadmin
      secret_key: minioadmin
      insecure: true
EOF
version_tag = "1.5.0"