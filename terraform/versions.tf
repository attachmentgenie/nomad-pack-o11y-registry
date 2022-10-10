terraform {
  required_version = "~> 1.2"
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.15.1"
    }
    minio = {
      source = "aminueza/minio"
      version = "1.6.0"
    }
  }
}

provider "consul" {
  address    = "nomad.gaggl.vagrant:8500"
  datacenter = "lab"
}

provider "minio" {
  minio_server       = "s3.gaggl.vagrant"
  minio_access_key   = "minioadmin"
  minio_secret_key   = "minioadmin"
}