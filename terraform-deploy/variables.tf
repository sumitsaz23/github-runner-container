variable "GH_TOKEN" {
  type      = string
  sensitive = true
}


variable "GITHUB_REPO" {
  type      = string
  sensitive = false
}


variable "container_name" {
  type      = string
  sensitive = false

}


variable "image_name" {
  type      = string
  sensitive = false

}