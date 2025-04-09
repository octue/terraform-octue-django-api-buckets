variable "server_service_account_email" {
  type = string
}


variable "project" {
  type    = string
  default = "bezier-app"
}


variable "resource_affix" {
  type = string
  default = "bezier"
}


variable "environment" {
  type = string
  default = "main"
}


variable "create_public_bucket" {
  type = bool
  default = false
}


variable "deletion_protection" {
  type = bool
  default = false
}
