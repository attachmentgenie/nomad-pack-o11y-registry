job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "phlare" {
    network {
      [[ if var "register_service" . ]]
      [[  $service_provider := var "service_provider" . ]]
      [[ if eq $service_provider "consul" ]]
      mode = "bridge"
      [[ end ]]
      [[ end ]]
      port "gossip" {
        to = 7946
      }
      port "grpc" {
        to = 9095
      }
      port "http" {
        to = 4100
      }
    }

    [[ template "volume" . ]]
    
    [[ if var "register_service" . ]]
    service {
      name     = "[[ var "service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      [[ range $tag := var "service_tags" . ]]
      tags     = [[ var "service_tags" . | toStringList ]]
      [[ end ]]
      port     = "http"
      check {
        type     = "http"
        path     = "/ready"
        interval = "10s"
        timeout  = "2s"
      }
      [[ if var "service_connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 4100
            [[ range $upstream := var "service_upstreams" . ]]
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
      name = "[[ var "service_name" . ]]-gossip"
      provider = "[[ var "service_provider" . ]]"
      port = "gossip"
    }
    service {
      name = "[[ var "service_name" . ]]-grpc"
      provider = "[[ var "service_provider" . ]]"
      port = "grpc"
    }
    [[ end ]]

    task "phlare" {
      driver = "docker"

      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = [[ var "volume_name" . | quote ]]
        destination = "/phlare"
        read_only   = false
      }
      [[- end ]]
      
      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        ports = ["gossip","grpc","http"]
        [[- if var "config_yaml" . ]]
        args = [
          "--config.file=/etc/phlare/config/phlare.yml",
        ]
        volumes = [
          "local/config:/etc/phlare/config",
        ]
        [[- end ]]
      }

      [[ template "resources" . ]]

        [[- if var "config_yaml" . ]]
      template {
        data = <<EOH
[[ var "config_yaml" . ]]
EOH
        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/phlare.yml"
      }
[[- end ]]
    }
  }
}
