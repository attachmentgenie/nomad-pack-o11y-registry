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
    cpu    = 200,
    memory = 256
  }
}

variable "image_name" {
  description = "The docker image name."
  type        = string
  default     = "grafana/grafana"
}

variable "image_tag" {
  description = "The docker image tag."
  type        = string
  default     = "latest"
}

variable "register_service" {
  description = "If you want to register a service for the job"
  type        = bool
  default     = false
}

variable "service_connect_enabled" {
  description = "If this service will announce itself to the service mesh. Only valid is 'service_provider == 'consul' "
  type        = bool
  default     = false
}

variable "service_name" {
  description = "The service name for the application."
  type        = string
  default     = "grafana"
}

variable "service_provider" {
  description = "Specifies the service registration provider to use for service registrations."
  type        = string
  default     = "consul"
}

variable "service_tags" {
  description = "The service name for the application."
  type        = list(string)
  default     = []
}

variable "service_upstreams" {
  description = ""
  type = list(object({
    name = string
    port = number
  }))
}

variable "volume_name" {
  description = "The name of the volume you want Jenkins to use."
  type        = string
}

variable "volume_type" {
  description = "The type of the volume you want Jenkins to use."
  type        = string
  default     = "host"
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables to pass to Docker container."
  default = {
    "GF_LOG_LEVEL" : "DEBUG",
    "GF_LOG_MODE" : "console"
    "GF_SERVER_HTTP_PORT" : "$${NOMAD_PORT_http}",
    "GF_PATHS_PROVISIONING" : "/local/grafana/provisioning"
  }
}

variable "grafana_task_artifacts" {
  description = "Define external artifacts for Grafana."
  type = list(object({
    source   = string
    destination = string
    mode   = string
    options = map(string)
  }))
  default = [
    {
      source = "https://grafana.com/api/dashboards/1860/revisions/26/download",
      destination = "local/grafana/provisioning/dashboards/linux/linux-node-exporter.json"
      mode = "file"
      options = null
    },
  ]
}

variable "grafana_task_config_dashboards" {
  description = "The yaml configuration for automatic provision of dashboards"
  type        = string
  default     = <<EOF
apiVersion: 1

providers:
  - name: dashboards
    type: file
    updateIntervalSeconds: 30
    options:
      foldersFromFilesStructure: true
      path: /local/grafana/provisioning/dashboards
EOF
}

variable "grafana_task_config_datasources" {
  description = "The yaml configuration for automatic provision of datasources"
  type        = string
  default     = <<EOF
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus.service.{{ env "NOMAD_DC" }}.consul:9090
    jsonData:
      exemplarTraceIdDestinations:
        - name: traceID
          datasourceUid: tempo
  - name: Tempo
    type: tempo
    access: proxy
    url: http://tempo.service.{{ env "NOMAD_DC" }}.consul:3200
    uid: tempo
  - name: Loki
    type: loki
    access: proxy
    url: http://loki.service.{{ env "NOMAD_DC" }}.consul:3100
    jsonData:
      derivedFields:
        - datasourceUid: tempo
          matcherRegex: (?:traceID|trace_id)=(\w+)
          name: TraceID
          url: $$${__value.raw}
EOF
}

variable "grafana_task_config_plugins" {
  description = "The yaml configuration for automatic provision of plugins"
  type        = string
}
