consul_service_tags = [
  "traefik.enable=true",
]
promlens_task = {
  driver   = "docker",
  version  = "v0.3.0",
  cli_args = [
    "--grafana.url=http://localhost:3000",
    "--grafana.api-token=glsa_ntddQFFtaRNaodsAdM3Rzjn01ZL1gt9z_a7c1e946"
  ]
}
promlens_upstreams = [{
  name = "grafana",
  port = 3000,
}]