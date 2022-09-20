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