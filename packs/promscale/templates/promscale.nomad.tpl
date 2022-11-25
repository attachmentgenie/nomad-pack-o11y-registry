job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "promscale" {
    count = [[ .my.count ]]

    network {
      mode = "bridge"
      port "timescaledb" {
        to = 5432
      }
      port "promscale" {
        to = 9201
      }
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      port = "promscale"
      check {
        name     = "alive"
        type     = "http"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 9201
          }
        }
      }
    }
    [[ end ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "timescaledb" {
      driver = "[[ .my.timescaledb_task.driver ]]"

      config {
        image = "timescale/timescaledb-ha:[[ .my.timescaledb_task.version ]]"
        ports = ["timescaledb"]
      }

      env {
        [[- range $var := .my.timescaledb_env_vars ]]
        [[ $var.key ]] = "[[ $var.value ]]"
        [[- end ]]
      }
    }

    task "promscale" {
      driver = "[[ .my.promscale_task.driver ]]"

      config {
        image = "timescale/promscale:[[ .my.promscale_task.version ]]"
        args  = [[ .my.promscale_task.cli_args | toPrettyJson ]]
        ports = ["promscale"]
      }
    }
  }
}
