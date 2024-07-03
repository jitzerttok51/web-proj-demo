terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = ""
}

# import {
#     id = "ec688386-dd4f-45aa-9cf7-30d35d08842b"
#     to = digitalocean_app.app
# }

resource "digitalocean_app" "demo-app" {
  spec {
    name     = "demo-app-test123"
    region   = "fra"

    service {
      http_port          = 8080
      instance_count     = 1
      instance_size_slug = "apps-s-1vcpu-0.5gb"
      name               = "demo-app-comp-test123"

      image {
        registry             = "jitzerttok51"
        registry_credentials = null # sensitive
        registry_type        = "GHCR"
        repository           = "web-proj-demo"
        tag                  = "1.0.4"
      }
    }
  }
}

