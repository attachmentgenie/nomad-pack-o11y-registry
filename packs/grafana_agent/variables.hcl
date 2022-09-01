variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  // If "", the pack name will be used
  default = ""
}

variable "namespace" {
  description = "The namespace where the job should be placed"
  type        = string
  default     = "default"
}

variable "region" {
  description = "The region where the job should be placed"
  type        = string
  default     = "global"
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["dc1"]
}

variable "count" {
  description = "The number of app instances to deploy"
  type        = number
  default     = 1
}

variable "message" {
  description = "The message your application will render"
  type        = string
  default     = "Hello World!"
}

variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = true
}

variable "consul_service_name" {
  description = "The consul service name for the grafana_agent application"
  type        = string
  default     = "grafana-agent"
}

variable "consul_service_tags" {
  description = "The consul service name for the grafana_agent application"
  type        = list(string)
  default = [
    "traefik.enable=true",
  ]
}

variable "grafana_agent_task" {
  description = "Details configuration options for the grafana_agent task."
  type        = object({
    driver   = string
    version  = string
    cli_args = list(string)
  })
  default = {
    driver   = "docker",
    version  = "v0.27.0",
    cli_args = [
      "-config.file=/etc/grafana_agent/grafana_agent.yml",
      "-metrics.wal-directory=/tmp/agent/wal",
      "-enable-features=integrations-next",
      "-config.expand-env",
      "-config.enable-read-api",
    ]
  }
}

variable "grafana_agent_task_resources" {
  description = "The resource to assign to the grafana_agent task."
  type        = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 500,
    memory = 256,
  }
}

variable "grafana_agent_task_app_grafana_agent_yaml" {
  description = "The grafana_agent configuration to pass to the task."
  type        = string
  default     = <<EOF
---
server:
  log_level: debug
metrics:
  global:
    scrape_interval: 60s
    remote_write:
      - url: http://192.168.1.11:25687/api/v1/push
  configs:
  - name: default
    scrape_configs:
    - job_name: agent
      static_configs:
      - targets: ['localhost:12345']
EOF
}
