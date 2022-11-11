datacenters = [
  "lab",
]
oncall_env_vars = [
    {key = "DATABASE_TYPE", value = "sqlite3"},
    {key = "BROKER_TYPE", value = "redis"},
    {key = "SECRET_KEY", value = "foobarbbqcorrecthorsebatterystaple"},
    {key = "REDIS_URI", value = "redis://192.168.1.11:31346/0"},
    {key = "DJANGO_SETTINGS_MODULE", value = "settings.hobby"},
    {key = "CELERY_WORKER_QUEUE", value = "default,critical,long,slack,telegram,webhook,retry,celery"},
    {key = "CELERY_WORKER_CONCURRENCY", value = "1"},
    {key = "CELERY_WORKER_MAX_TASKS_PER_CHILD", value = "100"},
    {key = "CELERY_WORKER_SHUTDOWN_INTERVAL", value = "65m"},
    {key = "CELERY_WORKER_BEAT_ENABLED", value = "True"},
  ]
version_tag = "v1.1.0"
