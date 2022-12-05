consul_service_tags = [
  "traefik.enable=true",
]
env_vars = [
  {key = "MINIO_ROOT_USER", value = "minioadmin"},
  {key = "MINIO_ROOT_PASSWORD", value = "minioadmin"},
  {key = "MINIO_PROMETHEUS_AUTH_TYPE", value = "public"},
]
version_tag = "RELEASE.2022-12-02T19-19-22Z"