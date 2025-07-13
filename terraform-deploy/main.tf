data "docker_registry_image" "image-github-runner" {
   name         = var.image_name
}

resource "docker_image" "image-github-runner" {
  name         = data.docker_registry_image.image-github-runner.name
  #name         = "sumitsur74/github-runner:2.325.0"
  keep_locally = true
  pull_triggers = [ data.docker_registry_image.image-github-runner.sha256_digest ]  

}


resource "docker_container" "tf-runner" {
  name    = var.container_name
  image   = docker_image.image-github-runner.image_id
  restart = "unless-stopped"
  memory  = 300
  #cpus    = "0.5"  #buggy in docker provider
  stop_signal = "SIGINT"
  destroy_grace_seconds = 30
  env = [

    "GH_ACCESS_TOKEN=${var.GH_TOKEN}",
    "GITHUB_REPOSITORY=  ${var.GITHUB_REPO}"
  ]
}