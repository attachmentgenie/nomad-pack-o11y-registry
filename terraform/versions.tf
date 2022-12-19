terraform {
  required_version = "~> 1.2"
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "2.16.2"
    }
    minio = {
      source  = "aminueza/minio"
      version = "1.9.1"
    }
  }
}

provider "consul" {
  address    = "192.168.1.10:8500"
  datacenter = "lab"
}

provider "minio" {
  minio_server   = "192.168.1.11:29192"
  minio_user     = "minioadmin"
  minio_password = "minioadmin"
}