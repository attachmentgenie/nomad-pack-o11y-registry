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
  description = "The consul service name for the prometheus_graphite_exporter application"
  type        = string
  default     = "graphite"
}

variable "consul_service_tags" {
  description = "The consul service name for the prometheus_graphite_exporter application"
  type        = list(string)
  default = [
    "traefik.enable=true",
  ]
}

variable "prometheus_graphite_exporter_task" {
  description = "Details configuration options for the prometheus_graphite_exporter task."
  type        = object({
    driver   = string
    version  = string
  })
  default = {
    driver   = "docker",
    version  = "v0.12.3",
  }
}

variable "prometheus_graphite_exporter_task_resources" {
  description = "The resource to assign to the prometheus_graphite_exporter task."
  type        = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 500,
    memory = 256,
  }
}
