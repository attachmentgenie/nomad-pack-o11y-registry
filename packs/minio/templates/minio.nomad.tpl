job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ .my.datacenters  | toStringList ]]
  type = "service"

  group "minio" {
    count = [[ .my.count ]]

    volume "minio" {
      type      = "host"
      read_only = false
      source    = "minio"
    }

    network {
      port "s3" {
        to = 9000
      }
    }

    [[ if .my.register_consul_service ]]
    service {
      name = "[[ .my.consul_service_name ]]"
      tags = [[ .my.consul_service_tags | toStringList ]]
      port = "s3"
      check {
        name     = "alive"
        type     = "http"
        path     = "/minio/health/live"
        interval = "10s"
        timeout  = "2s"
      }
    }
    [[ end ]]

    task "server" {
      driver = "docker"

      volume_mount {
        volume      = "minio"
        destination = "/data"
        read_only   = false
      }

      config {
        image = "quay.io/minio/minio"
        ports = ["s3"]
        args = [
          "server",
          "/data",
        ]
      }
    }
  }
}
