datacenters = [
  "lab",
]
grafana_consul_tags = [
  "traefik.enable=true",
  "metrics"
]
grafana_task_config_datasources = <<EOF
apiVersion: 1
datasources:
  - name: Loki
    type: loki
    access: proxy
    uid: loki
    url: http://192.168.1.11:22941
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
    url: http://192.168.1.11:25615/prometheus
    jsonData:
      exemplarTraceIdDestinations:
        - name: traceID
          datasourceUid: tempo
  - name: Tempo
    type: tempo
    access: proxy
    uid: tempo
    url: http://192.168.1.11:20082
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
grafana_version_tag = "9.1.6"