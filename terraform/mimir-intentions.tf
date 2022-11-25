resource "consul_config_entry" "dashboard-metrics" {
  name = data.consul_service.mimir.name
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = data.consul_service.grafana.name
      Precedence = 9
      Type       = "consul"
      },
      {
        Action     = "allow"
        Name       = data.consul_service.mimir_graphite_proxy.name
        Precedence = 9
        Type       = "consul"
      },
      {
        Action     = "allow"
        Name       = data.consul_service.prometheus.name
        Precedence = 9
        Type       = "consul"
    }]
  })
}
