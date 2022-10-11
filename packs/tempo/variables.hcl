variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name."
  type        = string
  // If "", the pack name will be used
  default = ""
}

variable "constraints" {
  description = "Constraints to apply to the entire job."
  type        = list(object({
    attribute = string
    operator  = string
    value     = string
  }))
  default = [
    {
      attribute = "$${attr.kernel.name}",
      value     = "linux",
      operator  = "",
    },
  ]
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["dc1"]
}

variable "region" {
  description = "The region where the job should be placed."
  type        = string
  default     = "global"
}

variable "namespace" {
  description = "The namespace where the job should be placed"
  type        = string
  default     = "default"
}

variable "version_tag" {
  description = "The docker image version. For options, see https://hub.docker.com/r/grafana/tempo"
  type        = string
  default     = "latest"
}

variable "http_port" {
  description = "The Nomad client port that routes to the tempo."
  type        = number
  default     = 3200
}

variable "grpc_port" {
  description = "The Nomad client port that routes to the tempo."
  type        = number
  default     = 9095
}

variable "resources" {
  description = "The resource to assign to the tempo service task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 200,
    memory = 256
  }
}

variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = true
}

variable "register_consul_connect_enabled" {
  description = "If you want to run the consul service with connect enabled. This will only work with register_consul_service = true"
  type        = bool
  default     = true
}

variable "consul_service_name" {
  description = "The consul service name for the tempo application"
  type        = string
  default     = "tempo"
}

variable "consul_service_tags" {
  description = "The consul service name for the tempo application"
  type        = list(string)
  default = []
}

variable "tempo_yaml" {
  description = "The Tempo configuration to pass to the task."
  type        = string
  // defaults as used in the upstream getting started tutorial.
  default     = ""
}

variable "tempo_upstreams" {
  description = ""
  type = list(object({
    name = string
    port = number
  }))
}