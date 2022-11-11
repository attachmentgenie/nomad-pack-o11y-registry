job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .loki.datacenters | toStringList ]]

  [[ if .loki.constraints ]][[ range $idx, $constraint := .loki.constraints ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    value     = [[ $constraint.value | quote ]]
    [[- if ne $constraint.operator "" ]]
    operator  = [[ $constraint.operator | quote ]]
    [[- end ]]
  }
  [[- end ]][[- end ]]

  group "loki" {
    count = [[ .loki.count ]]

    network {
      mode = "bridge"

      port "http" {
        to = [[ .loki.http_port ]]
      }
      port "gossip" {
        to = 7946
      }
      port "grpc" {
        to = [[ .loki.grpc_port ]]
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
        image = "grafana/loki:[[ .loki.version_tag ]]"
        ports = ["gossip","grpc","http"]
        [[- if ne .loki.loki_yaml "" ]]
        args = [
          "--config.file=/etc/loki/config/loki.yml",
        ]
        volumes = [
          "local/config:/etc/loki/config",
          [[- if ne .loki.rules_yaml "" ]]
          "local/rules:/etc/loki/rules/default",
          [[- end ]]
        ]
        [[- end ]]
      }

      resources {
        cpu    = [[ .loki.resources.cpu ]]
        memory = [[ .loki.resources.memory ]]
      }

      [[- if ne .loki.loki_yaml "" ]]
      template {
        data = <<EOH
[[ .loki.loki_yaml ]]
EOH
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/loki.yml"
      }
      [[- end ]]

      [[- if ne .loki.rules_yaml "" ]]
      template {
        data = <<EOH
[[ .loki.rules_yaml ]]
EOH
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/rules/rules.yaml"
      }
      [[- end ]]
    }
  }
}
