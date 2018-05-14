job "fabio" {
  datacenters = ["dc1"]

  type = "service"

  group "fabio" {
    count = 1

    task "fabio" {
      driver = "raw_exec"
      config {
        command = "fabio"
      }

      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.3/fabio-1.5.3-go1.9.2-${attr.kernel.name}_${attr.cpu.arch}"
        destination = "fabio"
        mode = "file"
      }

      env {
        registry_consul_addr = "127.0.0.1:8500"
        proxy_addr = ":${NOMAD_PORT_proxy}"

        registry_consul_register.addr = ":${NOMAD_PORT_ui}"
        ui_addr = ":${NOMAD_PORT_ui}"
      }

      resources {
        network {
          mbits = 1
          port "proxy" {
            static = 80
          }

          port "ui" {
            static = 9998
          }
        }
      }

      service {
        port = "proxy"

        name = "fabio"

        check {
          type = "http"
          port = "ui"
          path = "/health"
          interval = "1s"
          timeout = "1s"

          check_restart {
            limit = 3
            grace = "90s"
            ignore_warnings = false
          }
        }
      }
    }
  }
}
