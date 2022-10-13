consul_service_name = "graphite-proxy"
consul_service_health_tags = ["metrics"]
datacenters = [
  "lab",
]
mimir_graphite_proxy_task = {
  driver   = "docker",
  version  = "latest",
  cli_args = [
    "-auth.enable=false",
    " -write-endpoint http://{{ range $i, $s := service \"mimir\" }}{{ if eq $i 0 }}{{.Address}}:{{.Port}}{{end}}{{end}}/api/v1/push",
  ]
}
mimir_graphite_proxy_upstreams = [{
  name = "mimir",
  port = 9009
}]