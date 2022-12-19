task_config = {
  image   = "otel/opentelemetry-collector-contrib"
  version = "0.67.0"
  env     = {}
}
task_services = [{
  service_port       = 4317
  service_port_label = "otlp"
  service_name       = "otlp"
  service_tags       = []
  check_enabled      = false
  check_type         = "tcp"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
  connect_enabled    = true
  connect_upstreams  = [{
    name = "loki",
    port = 3100,
  },{
    name = "mimir",
    port = 9009,
  },{
    name = "tempo-oltp-grpc",
    port = 4317,
  }]
},
{
  service_port       = 4318
  service_port_label = "otlphttp"
  service_name       = "otlphttp"
  service_tags       = []
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
  connect_enabled    = false
  connect_upstreams  = []
},
{
  service_port       = 8888
  service_port_label = "metrics"
  service_name       = "opentelemetry-metrics"
  service_tags       = []
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
  connect_enabled    = false
  connect_upstreams  = []
},
{
  service_port       = 9411
  service_port_label = "zipkin"
  service_name       = "zipkin"
  service_tags       = []
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
  connect_enabled    = false
  connect_upstreams  = []
},
{
  service_port       = 13133
  service_port_label = "healthcheck"
  service_name       = "opentelemetry-health"
  service_tags       = []
  check_enabled      = true
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
  connect_enabled    = false
  connect_upstreams  = []
},
{
  service_port       = 14250
  service_port_label = "jaeger-grpc"
  service_name       = "jaeger-grpc"
  service_tags       = []
  check_enabled      = false
  check_type         = "tcp"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
  connect_enabled    = false
  connect_upstreams  = []
},
{
  service_port       = 14268
  service_port_label = "jaeger-thrift-http"
  service_name       = "jaeger-thrift-http"
  service_tags       = []
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
  connect_enabled    = false
  connect_upstreams  = []
},
{
  service_port       = 55679
  service_port_label = "zpages"
  service_name       = "zpages"
  service_tags       = []
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
  connect_enabled    = false
  connect_upstreams  = []
}]
otel_config_yaml = <<EOF
---
receivers:
  otlp:
    protocols:
      grpc:
      http:
  jaeger:
    protocols:
      grpc:
      thrift_http:
  zipkin: {}

processors:
  batch: {}

extensions:
  health_check: {}
  zpages: {}

exporters:
  loki:
    endpoint: https://localhost:3100/api/v1/push
  prometheusremotewrite:
    endpoint: https://localhost:9009/api/v1/push
  otlp:
    endpoint: localhost:4317 #port 4317 will be used by the otel-collector
    tls:
      insecure: true

service:
  extensions: [health_check, zpages]
  pipelines:
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [loki]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheusremotewrite]
    traces:
      receivers: [otlp, jaeger, zipkin]
      processors: [batch]
      exporters: [otlp]
EOF