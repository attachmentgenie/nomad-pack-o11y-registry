terraform {
  required_version = "~> 1.2"
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.15.1"
    }
  }
}

provider "consul" {
  address    = "192.168.1.10:8500"
  datacenter = "lab"
}