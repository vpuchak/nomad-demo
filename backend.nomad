job "backend" {
  region = "global"
  datacenters = ["dc1"]

  type = "service"

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "webs" {
    count = 1

    task "backend" {
      driver = "docker"

      config {
        image = "docker.io/vpuchak/hello-app-go:1.0"

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
          
          check_restart {
            limit = 3
            grace = "90s"
            ignore_warnings = false
          }
        }
      }

      env {
        "DB_HOST" = "db01.example.com"
        "DB_USER" = "web"
        "DB_PASS" = "loremipsum"
      }

      resources {
        cpu    = 128 # MHz
        memory = 32 # MB

        network {
          mbits = 1

          port "http" {}
        }
      }
    }
  }
}
