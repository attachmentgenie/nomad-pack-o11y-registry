datacenters = [
  "lab",
]
grafana_consul_tags = [
  "traefik.enable=true",
  "metrics"
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
  - name: Loki-Connect
    type: loki
    access: proxy
    uid: loki-connect
    url: http://localhost:3100
    jsonData:
      derivedFields:
        - datasourceUid: tempo
          matcherRegex: (?:traceID|trace_id)=(\w+)
          name: TraceID
          url: $$${__value.raw}
  - name: Mimir-Connect
    type: prometheus
    access: proxy
    uid: mimir-connect
    url: http://localhost:9010/prometheus
    jsonData:
      exemplarTraceIdDestinations:
        - name: traceID
          datasourceUid: tempo
  - name: Tempo-Connect
    type: tempo
    access: proxy
    uid: tempo-connect
    url: http://localhost:3200
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
grafana_version_tag = "9.1.7"