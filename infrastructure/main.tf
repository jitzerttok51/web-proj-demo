terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    key                         = "terraform.tfstate"
    bucket                      = "tf-backend-34512"
    region                      = "eu-central-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

variable "do_token" {}

variable "image_tag" {
  default = "latest"
}

provider "digitalocean" {
    token = var.do_token
}

# import {
#     id = "4dfe124d-0a59-4815-9d48-8703cae4ca7e"
#     to = digitalocean_database_cluster.database-example
# }

# import {
#     id = "4dfe124d-0a59-4815-9d48-8703cae4ca7e"
#     to = digitalocean_app.app
# }

# terraform plan -generate-config-out=out.tf

resource "digitalocean_database_cluster" "database-example" {
  name                 = "web-app-14194"

  node_count           = 1
  region               = "fra1"

  engine               = "mysql"
  version              = "8"
  
  size                 = "db-s-1vcpu-1gb"
  storage_size_mib     = "10240"
}

resource "digitalocean_database_user" "softuni-user" {
  cluster_id = digitalocean_database_cluster.database-example.id
  name = "softuni"
}

resource "digitalocean_database_db" "softuni-db" {
  cluster_id = digitalocean_database_cluster.database-example.id
  name = "softuni-db"
}

output "db_username" {
  value = digitalocean_database_user.softuni-user.name
}

output "db_password" {
  sensitive = true
  value = digitalocean_database_user.softuni-user.password
}

output "db" {
  value = digitalocean_database_db.softuni-db.name
}

locals {
  db_url = "jdbc:mysql://${digitalocean_database_cluster.database-example.host}:${digitalocean_database_cluster.database-example.port}/${digitalocean_database_db.softuni-db.name}"
}

output "connection_string" {
  value = local.db_url
}

resource "digitalocean_app" "demo-app" {
  spec {
    name     = "demo-app-test123"
    region   = "fra"

    service {
      http_port          = 8080
      instance_count     = 1
      instance_size_slug = "apps-s-1vcpu-0.5gb"
      name               = "demo-app-comp-test123"

      env {
        key = "DB_URL"
        value = local.db_url
        scope = "RUN_TIME"
        type = "GENERAL"
      }

      env {
        key = "DB_USER"
        value = digitalocean_database_user.softuni-user.name
        scope = "RUN_TIME"
        type = "GENERAL"
      }

      env {
        key = "DB_PASS"
        value = digitalocean_database_user.softuni-user.password
        scope = "RUN_TIME"
        type = "SECRET"
      }

      image {
        registry             = "jitzerttok51"
        registry_credentials = null # sensitive
        registry_type        = "GHCR"
        repository           = "web-proj-demo"
        tag                  = var.image_tag
      }
    }
  }
}