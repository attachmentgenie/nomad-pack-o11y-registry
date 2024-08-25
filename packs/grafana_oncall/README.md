# grafana_oncall

<!-- Include a brief description of your pack -->

This pack is a simple Nomad job that runs as a service and can be accessed via
HTTP.

## Pack Usage

<!-- Include information about how to use your pack -->

### Generate grafana oncall token

  python manage.py issue_invite_for_the_frontend --override

## Variables

<!-- Include information on the variables from your pack -->

- `message` (string) - The message your application will respond with
- `job_name` (string) - The name to use as the job name which overrides using
  the pack name
- `datacenters` (list of strings) - A list of datacenters in the region which
  are eligible for task placement
- `region` (string) - The region where jobs will be deployed

[pack-registry]: https://github.com/hashicorp/nomad-pack-community-registry
[pack-nginx]: https://github.com/hashicorp/nomad-pack-community-registry/tree/main/packs/nginx/README.md
[pack-haproxy]: https://github.com/hashicorp/nomad-pack-community-registry/tree/main/packs/haproxy/README.md
[pack-fabio]: https://github.com/hashicorp/nomad-pack-community-registry/tree/main/packs/fabio/README.md
[pack-traefik]: https://github.com/hashicorp/nomad-pack-community-registry/tree/main/packs/traefik/traefik/README.md
