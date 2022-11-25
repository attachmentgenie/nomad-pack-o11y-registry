resource "consul_config_entry" "oncall-dashboard" {
  name = data.consul_service.grafana.name
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = data.consul_service.oncall.name
      Precedence = 9
      Type       = "consul"
      },
      {
        Action     = "allow"
        Name       = data.consul_service.promlens.name
        Precedence = 9
        Type       = "consul"
    }]
  })
}
