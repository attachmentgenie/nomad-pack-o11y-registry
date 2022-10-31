consul_service_tags = [
  "traefik.enable=true",
]
datacenters = [
  "lab",
]
promlens_task = {
  driver   = "docker",
  version  = "latest",
  cli_args = [
    "--grafana.url=http://192.168.1.11:24529",
    "--grafana.api-token=eyJrIjoiN1gyWFFwNkxrR29KaVB2WGZ3U2hlNmc4Smw4ZDhmOU4iLCJuIjoicHJvbWxlbnMiLCJpZCI6MX0="
  ]
}