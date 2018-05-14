job "backend" {
  region = "global"
  datacenters = ["dc1"]

  type = "service"

  update {
    stagger      = "30s"
    max_parallel = 2
  }

  group "webs" {
    count = 1

    task "backend" {
      driver = "docker"

      config {
        image = "gcr.io/google-samples/hello-app:1.0"

        port_map {
          http = 8080
        }
      }

      service {
        name = "backend"
        port = "http"
        tags = ["urlprefix-/hello"]
        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      env {
        "DB_HOST" = "db01.example.com"
        "DB_USER" = "web"
        "DB_PASS" = "loremipsum"
      }

      resources {
        cpu    = 500 # MHz
        memory = 128 # MB

        network {
          mbits = 100
          
          port "http" {}
        }
      }
    }
  }
}
