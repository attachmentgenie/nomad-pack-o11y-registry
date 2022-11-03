#!/bin/bash
set -e

export NOMAD_ADDR=http://192.168.1.30:4646/ui/jobs
wait-for-url() {
    echo "Testing $1"
    timeout -s TERM 45 bash -c \
    'while [[ "$(curl -s -o /dev/null -L -w ''%{http_code}'' ${0})" != "200" ]];\
    do echo "Waiting for ${0}" && sleep 2;\
    done' ${1}
    echo "OK!"
}

nomad-pack run minio -f vars/minio.hcl --registry=attachmentgenie
wait-for-url https://s3.teambla.dev/minio/health/live

(cd terraform; terraform init; terraform apply -auto-approve)

nomad-pack run packs/loki -f vars/loki.hcl
nomad-pack run packs/mimir -f vars/mimir.hcl
nomad-pack run packs/phlare -f vars/phlare.hcl
nomad-pack run packs/tempo -f vars/tempo.hcl

wait-for-url https://loki.teambla.dev/ready
wait-for-url https://mimir.teambla.dev/ready
wait-for-url https://phlare.teambla.dev/ready
wait-for-url https://tempo.teambla.dev/ready

nomad-pack run redis -f vars/redis.hcl --registry=default
nomad-pack run packs/grafana_oncall -f vars/grafana_oncall.hcl
nomad-pack run packs/grafana -f vars/grafana.hcl

nomad-pack run packs/mimir_graphite_proxy -f vars/mimir_graphite_proxy.hcl
nomad-pack run packs/opentelemetry_collector -f vars/opentelemetry_collector.hcl
nomad-pack run packs/prometheus -f vars/prometheus.hcl
nomad-pack run packs/prometheus_graphite_exporter -f vars/prometheus_graphite_exporter.hcl

nomad-pack run packs/promlens -f vars/promlens.hcl