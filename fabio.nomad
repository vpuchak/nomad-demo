job "fabio" {
  datacenters = ["dc1"]
  type = "system"
  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "fabio" {
    task "fabio" {
      driver = "exec"

      config {
        command = "fabio-1.5.8-go1.10-linux_amd64"
        args = ["-proxy.addr=:80", "-registry.consul.addr", "127.0.0.1:8500", "-ui.addr=:9998"]
      }

      artifact {
        source = https://github.com/fabiolb/fabio/releases/download/v1.5.8/fabio-1.5.8-go1.10-linux_amd64"
      }

      resources {
        cpu = 20
        memory = 64
        network {
          mbits = 1

          port "http" {
            static = 80
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}
