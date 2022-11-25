register_consul_connect_enabled = true
oncall_env_vars = [
    {key = "DATABASE_TYPE", value = "sqlite3"},
    {key = "BROKER_TYPE", value = "redis"},
    {key = "SECRET_KEY", value = "foobarbbqcorrecthorsebatterystaple"},
    {key = "REDIS_URI", value = "redis://localhost:6379/0"},
    {key = "DJANGO_SETTINGS_MODULE", value = "settings.hobby"},
    {key = "CELERY_WORKER_QUEUE", value = "default,critical,long,slack,telegram,webhook,retry,celery"},
    {key = "CELERY_WORKER_CONCURRENCY", value = "1"},
    {key = "CELERY_WORKER_MAX_TASKS_PER_CHILD", value = "100"},
    {key = "CELERY_WORKER_SHUTDOWN_INTERVAL", value = "65m"},
    {key = "CELERY_WORKER_BEAT_ENABLED", value = "True"},
    {key = "COMPOSE_PROFILES", value = "with_grafana"},
    {key = "GRAFANA_API_URL", value = "http://localhost:3000"},
  ]
upstreams = [{
  name = "grafana",
  port = 3000,
},{
  name = "redis",
  port = 6379,
}]
version_tag = "v1.1.5"
