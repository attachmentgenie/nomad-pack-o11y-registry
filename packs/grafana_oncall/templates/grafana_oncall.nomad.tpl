job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]

  [[ if .my.constraints ]][[ range $idx, $constraint := .my.constraints ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    value     = [[ $constraint.value | quote ]]
    [[- if ne $constraint.operator "" ]]
    operator  = [[ $constraint.operator | quote ]]
    [[- end ]]
  }
  [[- end ]][[- end ]]

  group "grafana_oncall" {

    network {
      mode = "bridge"

      port "http" {
        to = 8080
      }
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      port = "http"
      [[ if .my.register_consul_connect_enabled ]]
      connect {
        sidecar_service {
          tags = [""]
          proxy {
            [[ range $upstream := .my.upstreams ]]
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

    volume "oncall" {
      type      = "host"
      read_only = false
      source    = "oncall"
    }

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
        image   = "grafana/oncall:[[ .my.version_tag ]]"
        command = "python3"
        args = [
          "manage.py",
          "migrate",
          "--noinput",
        ]
      }

      env {
        [[- range $var := .my.oncall_env_vars ]]
        [[ $var.key ]] = "[[ $var.value ]]"
        [[- end ]]
      }
      
      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }
            
      volume_mount {
        volume      = "oncall"
        destination = "/var/lib/oncall"
        read_only   = false
      }
    }

    task "engine" {
      driver = "docker"

      config {
        image   = "grafana/oncall:[[ .my.version_tag ]]"
        ports   = ["http"]
      }

      env {
        [[- range $var := .my.oncall_env_vars ]]
        [[ $var.key ]] = "[[ $var.value ]]"
        [[- end ]]
      }
      
      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }
            
      volume_mount {
        volume      = "oncall"
        destination = "/var/lib/oncall"
        read_only   = false
      }
    }

    task "celery" {
      driver = "docker"

      config {
        image   = "grafana/oncall:[[ .my.version_tag ]]"
        command = "./celery_with_exporter.sh"
      }

      env {
        [[- range $var := .my.oncall_env_vars ]]
        [[ $var.key ]] = "[[ $var.value ]]"
        [[- end ]]
      }
      
      resources {
        cpu    = [[ .my.resources.cpu ]]
        memory = [[ .my.resources.memory ]]
      }
            
      volume_mount {
        volume      = "oncall"
        destination = "/var/lib/oncall"
        read_only   = false
      }
    }
  }
}
