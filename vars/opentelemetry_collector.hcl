task_config = {
  image   = "otel/opentelemetry-collector-contrib"
  version = "0.66.0"
  env     = {}
}
task_services = [
{
  service_port_label = "otlp"
  service_name       = "opentelemetry-collector"
  service_tags       = []
  check_enabled      = false
  check_type         = "tcp"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
},
{
  service_port_label = "otlphttp"
  service_name       = "opentelemetry-collector"
  service_tags       = ["otlphttp"]
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
},
{
  service_port_label = "metrics"
  service_name       = "opentelemetry-collector"
  service_tags       = ["metrics"]
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
},
{
  service_port_label = "zipkin"
  service_name       = "opentelemetry-collector"
  service_tags       = ["zipkin"]
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
},
{
  service_port_label = "healthcheck"
  service_name       = "opentelemetry-collector"
  service_tags       = ["health"]
  check_enabled      = true
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
},
{
  service_port_label = "jaeger-grpc"
  service_name       = "opentelemetry-collector"
  service_tags       = ["jaeger-grpc"]
  check_enabled      = false
  check_type         = "tcp"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
},
{
  service_port_label = "jaeger-thrift-http"
  service_name       = "opentelemetry-collector"
  service_tags       = ["jaeger-thrift-http"]
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
},
{
  service_port_label = "zpages"
  service_name       = "opentelemetry-collector"
  service_tags       = ["zpages"]
  check_enabled      = false
  check_type         = "http"
  check_path         = "/"
  check_interval     = "15s"
  check_timeout      = "3s"
}]
