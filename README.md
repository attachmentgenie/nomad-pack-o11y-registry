# O11Y Nomad Pack Registry

This repository will hold a curated set of [Nomad Packs](https://github.com/hashicorp/nomad-pack) related to all things observability. 

See the [documentation on Writing Packs and Registries](https://github.com/hashicorp/nomad-pack/blob/main/docs/writing-packs.md) for more information.

This registry current holds packs for the following tools

* grafana_oncall
* grafana (fork from community registry)
* loki (fork from community registry)
* mimir
* mimir_graphite_proxy
* opentelemetry_collector (fork from community registry)
* phlare
* prometheus (fork from community registry)
* prometheus_graphite_exporter
* promlens
* tempo (fork from community registry)

## Adding the o11y Registry


```
nomad-pack registry add o11y github.com/attachmentgenie/nomad-pack-o11y-registry
```

To view the packs you can now deploy, run the `registry list` command.

```
nomad-pack registry list
```

Packs from this registry can now be deployed using the `run` command.
