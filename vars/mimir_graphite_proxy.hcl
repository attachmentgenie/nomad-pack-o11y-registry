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
    " -write-endpoint http://192.168.1.11:25615/api/v1/push",
  ]
}
mimir_graphite_proxy_upstreams = [{
  name = "mimir",
  port = 9009
}]