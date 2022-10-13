datacenters = [
  "lab",
]
grafana_consul_tags = [
  "traefik.enable=true",
  "metrics"
]
grafana_env_vars = [
    {key = "GF_LOG_LEVEL", value = "DEBUG"},
    {key = "GF_LOG_MODE", value = "console"},
    {key = "GF_SERVER_HTTP_PORT", value = "$${NOMAD_PORT_http}"},
    {key = "GF_PATHS_PROVISIONING", value = "/local/grafana/provisioning"},
    {key = "GF_AUTH_ANONYMOUS_ENABLED", value = "true"},
    {key = "GF_AUTH_ANONYMOUS_ORG_ROLE", value = "Admin"},
    {key = "GF_AUTH_DISABLE_LOGIN_FORM", value = "true"},
    {key = "GF_INSTALL_PLUGINS", value = "grafana-oncall-app,grafana-piechart-panel,jdbranham-diagram-panel"},
  ]
grafana_task_artifacts = []
grafana_task_config_datasources = <<EOF
apiVersion: 1
datasources:
  - name: Loki
    type: loki
    access: proxy
    uid: loki
    url: http://{{ range $i, $s := service "loki" }}{{ if eq $i 0 }}{{.Address}}:{{.Port}}{{end}}{{end}}
    jsonData:
      derivedFields:
        - datasourceUid: tempo
          matcherRegex: (?:traceID|trace_id)=(\w+)
          name: TraceID
          url: $$${__value.raw}
  - name: Mimir
    type: prometheus
    access: proxy
    uid: mimir
    isDefault: true
    url: http://{{ range $i, $s := service "mimir" }}{{ if eq $i 0 }}{{.Address}}:{{.Port}}{{end}}{{end}}/prometheus
    jsonData:
      exemplarTraceIdDestinations:
        - name: traceID
          datasourceUid: tempo
  - name: Tempo
    type: tempo
    access: proxy
    uid: tempo
    url: http://{{ range $i, $s := service "tempo" }}{{ if eq $i 0 }}{{.Address}}:{{.Port}}{{end}}{{end}}
    jsonData:
      httpMethod: GET
      tracesToLogs:
        datasourceUid: loki
      serviceMap:
        datasourceUid: mimir
      nodeGraph:
        enabled: true
      lokiSearch:
        datasourceUid: loki
EOF
grafana_upstreams = [{
  name = "loki",
  port = 3100,
},{
  name = "mimir",
  port = 9009,
},{
  name = "tempo",
  port = 3200,
}]
grafana_version_tag = "9.2.0"