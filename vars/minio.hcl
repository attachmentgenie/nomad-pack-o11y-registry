consul_service_tags = [
  "traefik.enable=true",
  "metrics"
]
datacenters = [
  "lab",
]
env_vars = [
  {key = "MINIO_ROOT_USER", value = "minioadmin"},
  {key = "MINIO_ROOT_PASSWORD", value = "minioadmin"},
]
version_tag = "RELEASE.2022-10-02T19-29-29Z"