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
  address    = "192.168.1.10:8500"
  datacenter = "lab"
}

provider "minio" {
  minio_server       = "192.168.1.11:24482"
  minio_access_key   = "minioadmin"
  minio_secret_key   = "minioadmin"
}