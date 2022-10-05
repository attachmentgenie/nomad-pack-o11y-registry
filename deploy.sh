#!/bin/bash
set -e

export NOMAD_ADDR=http://nomad.gaggl.vagrant:4646

nomad-pack run packs/minio -f vars/minio.hcl
(cd terraform; terraform init; terraform apply -auto-approve)

nomad-pack run packs/loki -f vars/loki.hcl
nomad-pack run packs/mimir -f vars/mimir.hcl
nomad-pack run packs/tempo -f vars/tempo.hcl

nomad-pack run packs/grafana -f vars/grafana.hcl

nomad-pack run packs/mimir_graphite_proxy -f vars/mimir_graphite_proxy.hcl
nomad-pack run packs/opentelemetry_collector -f vars/opentelemetry_collector.hcl
nomad-pack run packs/prometheus -f vars/prometheus.hcl
nomad-pack run packs/prometheus_graphite_exporter -f vars/prometheus_graphite_exporter.hcl
