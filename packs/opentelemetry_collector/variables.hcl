variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  // If "", the pack name will be used
  default = ""
}

variable "region" {
  description = "The region where jobs will be deployed"
  type        = string
  default     = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["*"]
}

variable "namespace" {
  description = "The namespace where the job should be placed."
  type        = string
  default     = "default"
}

variable "node_pool" {
  description = "The node_pool where the job should be placed."
  type        = string
  default     = "default"
}

variable "priority" {
  description = "The priority value the job will be given"
  type        = number
  default     = 50
}

variable "task_constraints" {
  description = "Constraints to apply to the entire job."
  type = list(object({
    attribute = string
    operator  = string
    value     = string
  }))
  default = [
    {
      attribute = "$${attr.kernel.name}",
      value     = "(linux|darwin)",
      operator  = "regexp",
    },
  ]
}

variable "task_resources" {
  description = "Resources used by jenkins task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 256
    memory = 512
  }
}

variable "image_name" {
  description = "The docker image name."
  type        = string
  default     = "otel/opentelemetry-collector-contrib"
}

variable "image_tag" {
  description = "The docker image tag."
  type        = string
  default     = "latest"
}

variable "privileged_mode" {
  description = "Determines if the OpenTelemetry Collector should run with privleged access to the host. Useful when using the hostmetrics receiver."
  type        = bool
  default     = false
}

variable "register_service" {
  description = "If you want to register a service for the job"
  type        = bool
  default     = false
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables to pass to Docker container."
  default     = {}
}

variable "network_config" {
  description = "The OpenTelemetry Collector network configuration options."
  type = object({
    mode  = string
    ports = map(number)
  })
  default = {
    mode = "bridge"
    ports = {
      "otlp"               = 4317
      "otlphttp"           = 4318
      "metrics"            = 8888
      "zipkin"             = 9411
      "healthcheck"        = 13133
      "jaeger-grpc"        = 14250
      "jaeger-thrift-http" = 14268
      "zpages"             = 55679
    }
  }
}

variable "config_yaml_location" {
  description = "The location of otel-collector-config.yaml in the OpenTelemetry Collector container instance"
  type        = string
  default     = "local/otel/config.yaml"
}

variable "otel_config_yaml" {
  description = "The OpenTelemetry Collector configuration to pass to the task."
  type        = string
  default     = <<EOF
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
  otlp:
    endpoint: "someotlp.target.com:443"
    headers:
      "x-someapi-header": "$SOME_API_KEY"
  logging:
    loglevel: info

service:
  extensions: [health_check, zpages]
  pipelines:
    traces:
      receivers: [otlp, jaeger, zipkin]
      processors: [batch]
      exporters: [otlp, logging]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp, logging]
EOF
}

variable "additional_templates" {
  description = "Additional job templates: access Consul KV, or the Vault KV or secrets engine. 'data' and 'destination' are required."
  type = list(object({
    data          = string
    destination   = string
    change_mode   = string
    change_signal = string
    env           = bool
    perms         = string
  }))
  default = []
}

variable "task_services" {
  description = "Configuration options of the OpenTelemetry Collector services and checks."
  type = list(object({
    service_port       = number
    service_port_label = string
    service_provider   = string
    service_name       = string
    service_tags       = list(string)
    check_enabled      = bool
    check_type         = string
    check_path         = string
    check_interval     = string
    check_timeout      = string
    connect_enabled    = bool
    connect_upstreams = list(object({
      name = string
      port = number
    }))
  }))
  default = [
    {
      service_port       = 4317
      service_port_label = "otlp"
      service_provider   = "consul"
      service_name       = "otlp"
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
      service_port       = 4318
      service_port_label = "otlphttp"
      service_provider   = "consul"
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
      service_provider   = "consul"
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
      service_provider   = "consul"
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
      service_provider   = "consul"
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
      service_provider   = "consul"
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
      service_provider   = "consul"
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
      service_provider   = "consul"
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
}
