consul_service_tags = [
  "traefik.enable=true",
]
datacenters = [
  "lab",
]
env_vars = [
  {key = "MINIO_ROOT_USER", value = "minioadmin"},
  {key = "MINIO_ROOT_PASSWORD", value = "minioadmin"},
  {key = "MINIO_PROMETHEUS_AUTH_TYPE", value = "public"},
]
version_tag = "RELEASE.2022-10-02T19-29-29Z"