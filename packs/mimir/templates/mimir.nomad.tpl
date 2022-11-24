job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "mimir" {
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

    [[- if .my.mimir_volume ]]
    volume "mimir" {
      type = [[ .my.mimir_volume.type | quote ]]
      read_only = false
      source = [[ .my.mimir_volume.source | quote ]]
    }
    [[- end ]]
    
    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      port = "http"
      
      check {
        type     = "http"
        path     = "/ready"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if .my.register_consul_service ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = [[ .my.http_port ]]
            [[ range $upstream := .my.mimir_upstreams ]]
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
      driver = "[[ .my.mimir_task.driver ]]"

      [[- if .my.mimir_volume ]]
      volume_mount {
        volume      = [[ .my.mimir_volume.name | quote ]]
        destination = "/mimir"
        read_only   = false
      }
      [[- end ]]

      config {
        image = "grafana/mimir:[[ .my.mimir_task.version ]]"
        args = [[ .my.mimir_task.cli_args | toPrettyJson ]]
        ports = ["gossip","grpc","http"]
        volumes = [
          "local/config:/etc/mimir",
        ]
      }

      [[- if ne .my.mimir_task_app_mimir_yaml "" ]]
      template {
        data = <<EOH
[[ .my.mimir_task_app_mimir_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/mimir.yml"
      }
      [[- end ]]

      [[- if ne .my.mimir_task_alertmanager_mimir_yaml "" ]]
      template {
        data = <<EOH
[[ .my.mimir_task_alertmanager_mimir_yaml ]]
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/alertmanager.yml"
      }
      [[- end ]]
    }
  }
}
