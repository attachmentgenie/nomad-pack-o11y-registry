job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .phlare.datacenters | toStringList ]]

  [[ if .phlare.constraints ]][[ range $idx, $constraint := .phlare.constraints ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    value     = [[ $constraint.value | quote ]]
    [[- if ne $constraint.operator "" ]]
    operator  = [[ $constraint.operator | quote ]]
    [[- end ]]
  }
  [[- end ]][[- end ]]

  group "phlare" {
    count = [[ .my.count ]]

    network {
      mode = "bridge"

      port "gossip" {
        to = 7946
      }
      port "grpc" {
        to = [[ .phlare.grpc_port ]]
      }
      port "http" {
        to = [[ .phlare.http_port ]]
      }
    }

    [[ if .phlare.register_consul_service ]]
    service {
      name = "[[ .phlare.consul_service_name ]]"
      tags = [[ .phlare.consul_service_tags | toStringList ]]
      port = "http"
      [[ if .phlare.register_consul_connect_enabled ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            [[ range $upstream := .phlare.phlare_upstreams ]]
            upstreams {
              destination_name = [[ $upstream.name | quote ]]
              local_bind_port  = [[ $upstream.port ]]
            }
            [[ end ]]
          }
        }
      }
      [[ end ]]
    }
    service {
      name = "[[ .phlare.consul_service_name ]]-gossip"
      port = "gossip"
    }
    service {
      name = "[[ .phlare.consul_service_name ]]-grpc"
      port = "grpc"
    }
    [[ end ]]

    task "phlare" {
      driver = "docker"

      config {
        image = "grafana/phlare:[[ .phlare.version_tag ]]"
        ports = ["gossip","grpc","http"]
        [[- if ne .phlare.phlare_yaml "" ]]
        args = [
          "--config.file=/etc/phlare/config/phlare.yml",
        ]
        volumes = [
          "local/config:/etc/phlare/config",
        ]
        [[- end ]]
      }

      resources {
        cpu    = [[ .phlare.resources.cpu ]]
        memory = [[ .phlare.resources.memory ]]
      }

      [[- if ne .phlare.phlare_yaml "" ]]
      template {
        data = <<EOH
[[ .phlare.phlare_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/phlare.yml"
      }
[[- end ]]
    }
  }
}
