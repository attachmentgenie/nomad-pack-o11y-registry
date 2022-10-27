variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  // If "", the pack name will be used
  default     = ""
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

variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = true
}

variable "consul_service_name" {
  description = "The consul service name for the promlens application"
  type        = string
  default     = "promlens"
}

variable "consul_service_tags" {
  description = "The consul service name for the promlens application"
  type        = list(string)
  default = []
}

variable "promlens_task" {
  description = "Details configuration options for the promlens task."
  type        = object({
    driver   = string
    version  = string
    cli_args = list(string)
  })
  default = {
    driver   = "docker",
    version  = "latest",
    cli_args = []
  }
}

variable "promlens_upstreams" {
  description = ""
  type = list(object({
    name = string
    port = number
  }))
}
