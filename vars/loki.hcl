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