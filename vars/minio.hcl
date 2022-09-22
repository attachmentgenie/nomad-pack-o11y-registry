consul_service_tags = ["metrics"]
datacenters = [
  "lab",
]
env_vars = [
  {key = "MINIO_ROOT_USER", value = "minioadmin"},
  {key = "MINIO_ROOT_PASSWORD", value = "minioadmin"},
]