# O11Y Nomad Pack Registry

This repository will hold a curated set of [Nomad Packs](https://github.com/hashicorp/nomad-pack) related to all things observability. 

See the [documentation on Writing Packs and Registries](https://github.com/hashicorp/nomad-pack/blob/main/docs/writing-packs.md) for more information.

This registry current holds packs for the following tools

* [WIP] coroot
* grafana (fork from community registry)
* grafana_oncall
* loki (fork from community registry)
* mimir
* opentelemetry_collector (fork from community registry)
* phlare
* prometheus (fork from community registry)
* prometheus_blackbox_exporter
* promlens
* tempo (fork from community registry)

## Deploy packs from this nomad-pack registry

Add your custom repository using the `nomad-pack registry add` command.

```
nomad-pack registry add o11y github.com/attachmentgenie/nomad-pack-o11y-registry
```

Deploy your custom packs.

```
nomad-pack run grafana --registry=o11y
```

Congrats! You can now write custom packs for Nomad!