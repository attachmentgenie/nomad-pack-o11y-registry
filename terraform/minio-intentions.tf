resource "consul_config_entry" "mimir-s3" {
  name = data.consul_service.minio.name
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [{
      Action     = "allow"
      Name       = data.consul_service.mimir.name
      Precedence = 9
      Type       = "consul"
    },
    {
      Action     = "allow"
      Name       = data.consul_service.loki.name
      Precedence = 9
      Type       = "consul"
    },
    {
      Action     = "allow"
      Name       = data.consul_service.tempo.name
      Precedence = 9
      Type       = "consul"
    }]
  })
}
