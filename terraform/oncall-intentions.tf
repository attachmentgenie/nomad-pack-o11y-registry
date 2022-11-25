resource "consul_config_entry" "dashboard-oncall" {
  name = data.consul_service.oncall.name
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = data.consul_service.grafana.name
      Precedence = 9
      Type       = "consul"
    }]
  })
}
