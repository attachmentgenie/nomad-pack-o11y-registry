grafana_consul_tags = [
  "traefik.enable=true",
  "metrics"
]
grafana_env_vars = [
    {key = "GF_LOG_MODE", value = "console"},
    {key = "GF_SERVER_HTTP_PORT", value = "$${NOMAD_PORT_http}"},
    {key = "GF_PATHS_PROVISIONING", value = "/local/grafana/provisioning"},
    {key = "GF_AUTH_ANONYMOUS_ENABLED", value = "true"},
    {key = "GF_AUTH_ANONYMOUS_ORG_ROLE", value = "Admin"},
    {key = "GF_INSTALL_PLUGINS", value = "grafana-oncall-app,grafana-piechart-panel,jdbranham-diagram-panel"},
    {key = "GF_FEATURE_TOGGLES_ENABLE", value = "flameGraph"},
  ]
grafana_task_artifacts = []
grafana_task_config_datasources = <<EOF
apiVersion: 1
datasources:
  - name: Alertmanager
    type: alertmanager
    access: proxy
    uid: alertmanager
    url: http://localhost:9009/alertmanager
    jsonData:
      implementation: prometheus
  - name: Loki
    type: loki
    access: proxy
    uid: loki
    url: http://localhost:3100
    jsonData:
      alertmanagerUid: alertmanager
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
    url: http://localhost:9009/prometheus
    jsonData:
      alertmanagerUid: alertmanager
      exemplarTraceIdDestinations:
        - name: traceID
          datasourceUid: tempo
  - name: Phlare
    type: phlare
    access: proxy
    uid: phlare
    url: http://localhost:4100
  - name: Tempo
    type: tempo
    access: proxy
    uid: tempo
    url: http://localhost:3200
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
  name = "oncall",
  port = 8080,
},{
  name = "phlare",
  port = 4100,
},{
  name = "tempo",
  port = 3200,
}]
grafana_version_tag = "9.3.1"