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
  description = "The consul service name for the prometheus_graphite_exporter application"
  type        = string
  default     = "mimir"
}

variable "consul_service_tags" {
  description = "The consul service name for the prometheus_graphite_exporter application"
  type        = list(string)
  default = []
}

variable "mimir_task" {
  description = "Details configuration options for the mimir task."
  type        = object({
    driver   = string
    version  = string
    cli_args = list(string)
  })
  default = {
    driver   = "docker",
    version  = "2.3.0-rc0",
    cli_args = [
      "--config.file=/etc/mimir/mimir.yml",
    ]
  }
}

variable "mimir_task_resources" {
  description = "The resource to assign to the mimir task."
  type        = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 500,
    memory = 256,
  }
}

variable "mimir_task_app_mimir_yaml" {
  description = "The mimir configuration to pass to the task."
  type        = string
  default     = <<EOF
# Do not use this configuration in production.
# It is for demonstration purposes only.
multitenancy_enabled: false

blocks_storage:
  backend: filesystem
  bucket_store:
    sync_dir: /tmp/mimir/tsdb-sync
  filesystem:
    dir: /tmp/mimir/data/tsdb
  tsdb:
    dir: /tmp/mimir/tsdb

compactor:
  data_dir: /tmp/mimir/compactor
  sharding_ring:
    kvstore:
      store: memberlist

distributor:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: memberlist

ingester:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: memberlist
    replication_factor: 1

ruler_storage:
  backend: filesystem
  filesystem:
    dir: /tmp/mimir/rules

server:
  log_level: error

store_gateway:
  sharding_ring:
    replication_factor: 1
EOF
}

variable "mimir_upstreams" {
  description = ""
  type = list(object({
    name = string
    port = number
  }))
}
