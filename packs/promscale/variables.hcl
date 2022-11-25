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

variable "register_consul_service" {
  description = "If you want to register a consul service for the job"
  type        = bool
  default     = true
}

variable "consul_service_name" {
  description = "The consul service name for the promscale application"
  type        = string
  default     = "promscale"
}

variable "consul_service_tags" {
  description = "The consul service name for the promscale application"
  type        = list(string)
  default = []
}

variable "promscale_task" {
  description = "Details configuration options for the promscale task."
  type        = object({
    driver   = string
    version  = string
    cli_args = list(string)
  })
  default = {
    driver   = "docker",
    version  = "latest",
    cli_args = [
      "-db.password=mysecretpassword",
      "-db.port=$${NOMAD_HOST_PORT_timescaledb}",
      "-db.name=postgres",
      "-db.host=$${NOMAD_IP_timescaledb}",
      "-db.ssl-mode=allow",
    ]
  }
}

variable "timescaledb_env_vars" {
  description = "Environment variables for the timescaledb task"
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    {key = "POSTGRES_PASSWORD", value = "mysecretpassword"},
    {key = "TSTUNE_PROFILE", value = "promscale"}
  ]
}

variable "timescaledb_task" {
  description = "Details configuration options for the promscale task."
  type        = object({
    driver   = string
    version  = string
  })
  default = {
    driver   = "docker",
    version  = "pg14-latest",
  }
}
