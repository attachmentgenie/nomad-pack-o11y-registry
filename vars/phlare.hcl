datacenters = [
  "lab",
]
count = 2
consul_service_tags = [
  "traefik.enable=true",
  "metrics"
]
phlare_upstreams = [{
  name = "s3",
  port = 9000
}]
phlare_yaml = <<EOF
memberlist:
  join_members:
    - dnssrv+_phlare-gossip._tcp.service.consul
storage:
  backend: s3
  s3:
    bucket_name: profiling
    endpoint: {{ range $i, $s := service "s3" }}{{ if eq $i 0 }}{{.Address}}:{{.Port}}{{end}}{{end}}
    access_key_id: minioadmin
    secret_access_key: minioadmin
    insecure: true
EOF
version_tag = "0.1.0"