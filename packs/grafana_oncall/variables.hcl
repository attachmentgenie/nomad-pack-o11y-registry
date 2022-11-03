variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
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

variable "resources" {
  description = "The resource to assign to the my service task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 200,
    memory = 256
  }
}

variable "region" {
  description = "The region where jobs will be deployed"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace where the job should be placed"
  type        = string
  default     = "default"
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
  description = "The consul service name for the grafana_oncall application"
  type        = string
  default     = "oncall"
}

variable "consul_service_tags" {
  description = "The consul service name for the grafana_oncall application"
  type        = list(string)
  default = []
}

variable "oncall_env_vars" {
  description = ""
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    {key = "DATABASE_TYPE", value = "sqlite3"},
    {key = "BROKER_TYPE", value = "redis"},
    {key = "SECRET_KEY", value = "foobarbbqcorrecthorsebatterystaple"},
    {key = "REDIS_URI", value = "redis://192.168.1.11:27432/0"},
    {key = "DJANGO_SETTINGS_MODULE", value = "settings.hobby"},
    {key = "CELERY_WORKER_QUEUE", value = "default,critical,long,slack,telegram,webhook,retry,celery"},
    {key = "CELERY_WORKER_CONCURRENCY", value = "1"},
    {key = "CELERY_WORKER_MAX_TASKS_PER_CHILD", value = "100"},
    {key = "CELERY_WORKER_SHUTDOWN_INTERVAL", value = "65m"},
    {key = "CELERY_WORKER_BEAT_ENABLED", value = "True"},
  ]
}

variable "version_tag" {
  description = "The docker image version. For options, see https://hub.docker.com/grafana/loki"
  type        = string
  default     = "latest"
}
