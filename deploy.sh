#!/bin/bash
set -e

export NOMAD_ADDR=http://nomad.gaggl.vagrant:4646
wait-for-url() {
    echo "Testing $1"
    timeout -s TERM 45 bash -c \
    'while [[ "$(curl -s -o /dev/null -L -w ''%{http_code}'' ${0})" != "200" ]];\
    do echo "Waiting for ${0}" && sleep 2;\
    done' ${1}
    echo "OK!"
}

nomad-pack run packs/minio -f vars/minio.hcl
wait-for-url http://s3.gaggl.vagrant/minio/health/live

(cd terraform; terraform init; terraform apply -auto-approve)

nomad-pack run packs/loki -f vars/loki.hcl
nomad-pack run packs/mimir -f vars/mimir.hcl
nomad-pack run packs/tempo -f vars/tempo.hcl

wait-for-url http://loki.gaggl.vagrant/ready
wait-for-url http://mimir.gaggl.vagrant/ready
wait-for-url http://tempo.gaggl.vagrant/ready

nomad-pack run packs/grafana -f vars/grafana.hcl

nomad-pack run packs/mimir_graphite_proxy -f vars/mimir_graphite_proxy.hcl
nomad-pack run packs/opentelemetry_collector -f vars/opentelemetry_collector.hcl
nomad-pack run packs/prometheus -f vars/prometheus.hcl
nomad-pack run packs/prometheus_graphite_exporter -f vars/prometheus_graphite_exporter.hcl
