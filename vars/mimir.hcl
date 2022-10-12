consul_service_tags = [
  "traefik.enable=true",
  "metrics"
]
count = 2
datacenters = [
  "lab",
]
mimir_task = {
  driver   = "docker",
  version  = "2.3.1",
  cli_args = [
    "-target=all,alertmanager",
    "-auth.multitenancy-enabled=false",
    "-memberlist.join=dnssrv+_mimir-gossip._tcp.service.consul",
    "-common.storage.backend=s3",
    "-common.storage.s3.endpoint=192.168.56.40:21582",
    "-common.storage.s3.access-key-id=minioadmin",
    "-common.storage.s3.secret-access-key=minioadmin",
    "-common.storage.s3.insecure=true",
    "-alertmanager-storage.s3.bucket-name=mimir-alertmanager",
    "-blocks-storage.s3.bucket-name=metrics",
    "-ruler-storage.s3.bucket-name=mimir-rules"
  ]
}
mimir_upstreams = [{
  name = "s3",
  port = 9000,
}]