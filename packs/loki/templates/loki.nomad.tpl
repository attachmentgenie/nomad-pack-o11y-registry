job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters | toStringList ]]

  [[ if .my.constraints ]][[ range $idx, $constraint := .my.constraints ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    value     = [[ $constraint.value | quote ]]
    [[- if ne $constraint.operator "" ]]
    operator  = [[ $constraint.operator | quote ]]
    [[- end ]]
  }
  [[- end ]][[- end ]]

  group "loki" {
    count = [[ .my.count ]]

    network {
      mode = "bridge"

      port "gossip" {
        to = [[ .my.gossip_port ]]
      }
      port "grpc" {
        to = [[ .my.grpc_port ]]
      }
      port "http" {
        to = [[ .my.http_port ]]
      }
    }

    [[- if .my.loki_volume ]]
    volume "loki" {
      type = [[ .my.loki_volume.type | quote ]]
      read_only = false
      source = [[ .my.loki_volume.source | quote ]]
    }
    [[- end ]]
    
    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      port = "http"
      [[ if .my.register_consul_connect_enabled ]]

      check {
        type     = "http"
        path     = "/ready"
        interval = "10s"
        timeout  = "2s"
      }
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = [[ .my.http_port ]]
            [[ range $upstream := .my.loki_upstreams ]]
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
      name = "[[ .my.consul_service_name ]]-gossip"
      port = "gossip"
    }
    service {
      name = "[[ .my.consul_service_name ]]-grpc"
      port = "grpc"
    }
    [[ end ]]

    task "server" {
      driver = "docker"

      [[- if .my.loki_volume ]]
      volume_mount {
        volume      = [[ .my.loki_volume.name | quote ]]
        destination = "/loki"
        read_only   = false
      }
      [[- end ]]

      config {
        image = "grafana/loki:[[ .my.version_tag ]]"
        ports = ["gossip","grpc","http"]
        [[- if ne .my.loki_yaml "" ]]
        args = [
          "--config.file=/etc/loki/config/loki.yml",
        ]
        volumes = [
          "local/config:/etc/loki/config",
          [[- if ne .my.rules_yaml "" ]]
          "local/rules:/etc/loki/rules/default",
          [[- end ]]
        ]
        [[- end ]]
      }

      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }

      [[- if ne .my.loki_yaml "" ]]
      template {
        data = <<EOH
[[ .my.loki_yaml ]]
EOH
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/loki.yml"
      }
      [[- end ]]

      [[- if ne .my.rules_yaml "" ]]
      template {
        data = <<EOH
[[ .my.rules_yaml ]]
EOH
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/rules/rules.yaml"
      }
      [[- end ]]
    }
  }
}
