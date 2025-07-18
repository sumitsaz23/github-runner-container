terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

#provider "docker" {
#  host = "unix:///var/run/docker.sock"
#}

provider "docker" {
  host     = "ssh://pi@192.168.1.10:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}