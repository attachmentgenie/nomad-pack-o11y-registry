consul_service_name = "graphite-proxy"
consul_service_tags = ["metrics"]
datacenters = [
  "lab",
]
mimir_graphite_proxy_task = {
  driver   = "docker",
  version  = "latest",
  cli_args = [
    "-auth.enable=false",
    " -write-endpoint http://localhost:9009/api/v1/push",
  ]
}
mimir_graphite_proxy_upstreams = [{
  name = "mimir",
  port = 9009
}]