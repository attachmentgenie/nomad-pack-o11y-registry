job [[ template "job_name" . ]] {
  [[ template "placement" . ]]
  type = "service"

  group "grafana_oncall" {

    network {
      [[ if var "register_service" . ]]
      mode = "bridge"
      [[ end ]]
      port "http" {
        to = 8080
      }
    }

    [[ if var "register_service" . ]]
    service {
      name     = "[[ var "service_name" . ]]"
      provider = "[[ var "service_provider" . ]]"
      [[ range $tag := var "service_tags" . ]]
      tags     = [[ var "service_tags" . | toStringList ]]
      [[ end ]]
      port     = "http"
      [[ if var "service_connect_enabled" . ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            local_service_port = 8080
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
    [[ end ]]

    [[ template "volume" . ]]

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "oncall_db_migration" {
      driver = "docker"
    
      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        command = "python3"
        args = [
          "manage.py",
          "migrate",
          "--noinput",
        ]
      }

      [[ template "env_upper" . ]]
      
      [[ template "resources" . ]]
            
      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = [[ var "volume_name" . | quote ]]
        destination = "/var/lib/oncall"
        read_only   = false
      }
      [[- end ]]
    }

    task "engine" {
      driver = "docker"

      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        ports   = ["http"]
      }

      [[ template "env_upper" . ]]

      [[ template "resources" . ]]
            
      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = [[ var "volume_name" . | quote ]]
        destination = "/var/lib/oncall"
        read_only   = false
      }
      [[- end ]]
    }

    task "celery" {
      driver = "docker"

      config {
        image   = "[[ var "image_name" . ]]:[[ var "image_tag" . ]]"
        command = "./celery_with_exporter.sh"
      }

      [[ template "env_upper" . ]]

      [[ template "resources" . ]]
            
      [[ if var "volume_name" . ]]
      volume_mount {
        volume      = [[ var "volume_name" . | quote ]]
        destination = "/var/lib/oncall"
        read_only   = false
      }
      [[- end ]]
    }
  }
}
