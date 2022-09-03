consul_service_name = "graphite-proxy"
datacenters = [
  "lab",
]
mimir_graphite_proxy_task = {
  driver   = "docker",
  version  = "latest",
  cli_args = [
    "-auth.enable=false",
    " -write-endpoint http://192.168.1.11:27427/api/v1/push",
  ]
}