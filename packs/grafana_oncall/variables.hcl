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
  default     = "grafana/oncall"
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
  default     = "oncall"
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
    "DATABASE_TYPE" : "sqlite3",
    "BROKER_TYPE" : "redis",
    "SECRET_KEY" : "foobarbbqcorrecthorsebatterystaple",
    "REDIS_URI" : "redis://redis.service.consul:6379/0",
    "DJANGO_SETTINGS_MODULE" : "settings.hobby",
    "CELERY_WORKER_QUEUE" : "default,critical,long,slack,telegram,webhook,retry,celery",
    "CELERY_WORKER_CONCURRENCY" : "1",
    "CELERY_WORKER_MAX_TASKS_PER_CHILD" : "100",
    "CELERY_WORKER_SHUTDOWN_INTERVAL" : "65m",
    "CELERY_WORKER_BEAT_ENABLED" : "True"
  }
}
