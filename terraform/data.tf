data "consul_service" "grafana" {
  name = "grafana"
}

data "consul_service" "loki" {
  name = "loki"
}

data "consul_service" "oncall" {
  name = "oncall"
}

data "consul_service" "promlens" {
  name = "promlens"
}

data "consul_service" "mimir" {
  name = "mimir"
}

data "consul_service" "mimir_graphite_proxy" {
  name = "graphite-proxy"
}

data "consul_service" "minio" {
  name = "s3"
}

data "consul_service" "prometheus" {
  name = "prometheus"
}

data "consul_service" "tempo" {
  name = "tempo"
}
