consul_service_tags = [
  "traefik.enable=true",
  "metrics"
]
count = 2
mimir_task = {
  driver   = "docker",
  version  = "2.3.1",
  cli_args = [
    "-config.file=/etc/mimir/mimir.yml",
  ]
}
mimir_task_alertmanager_mimir_yaml = <<EOH
route:
  receiver: empty-receiver
receivers:
  - name: 'empty-receiver'
EOH
mimir_task_app_mimir_yaml = <<EOH
target: all,alertmanager
multitenancy_enabled: false
memberlist:
  join_members:
      - dnssrv+_mimir-gossip._tcp.service.consul
alertmanager:
  fallback_config_file: /etc/mimir/alertmanager.yml
alertmanager_storage:
  s3:
    bucket_name: mimir-alertmanager
blocks_storage:
  s3:
    bucket_name: metrics
common:
  storage:
    backend: s3
    s3:
      access_key_id: minioadmin
      endpoint: {{ range $i, $s := service "s3" }}{{ if eq $i 0 }}{{.Address}}:{{.Port}}{{end}}{{end}}
      insecure: true
      secret_access_key: minioadmin
ruler_storage:
  s3:
    bucket_name: mimir-rules
EOH
mimir_upstreams = [{
  name = "s3",
  port = 9000,
}]