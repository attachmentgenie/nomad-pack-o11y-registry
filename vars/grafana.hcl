datacenters = [
  "lab",
]
grafana_task_config_datasources = <<EOF
apiVersion: 1
datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://192.168.1.11:21015
    jsonData:
      derivedFields:
        - datasourceUid: tempo
          matcherRegex: (?:traceID|trace_id)=(\w+)
          name: TraceID
          url: $$${__value.raw}
  - name: Mimir
    type: prometheus
    access: proxy
    url: http://192.168.1.11:27427/prometheus
    uid: mimir
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://192.168.1.11:23636
    jsonData:
      exemplarTraceIdDestinations:
        - name: traceID
          datasourceUid: tempo
  - name: Tempo
    type: tempo
    access: proxy
    url: http://192.168.1.11:25096
    uid: tempo
EOF