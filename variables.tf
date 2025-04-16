variable "server_service_account_email" {
  type = string
  description = "The email address of the service account for running the Django server."
}


variable "google_cloud_project_id" {
  type        = string
  description = "The ID of the GCP project to deploy resources in."
}


variable "resource_affix" {
  type        = string
  description = "The affix to add to each resource controlled by this module."
}


variable "environment" {
  type        = string
  default     = "main"
  description = "The name of the environment to deploy the resources in (must be one word with no hyphens or underscores in). This can be derived from a Terraform workspace name and used to facilitate e.g. testing and staging environments alongside the production environment ('main')."
}


variable "create_public_bucket" {
  type        = bool
  default     = false
  description = "If `true`, create a public assets bucket."
}


variable "deletion_protection" {
  type        = bool
  default     = false
  description = "If `true`, disallow deletion of the cloud storage buckets. `terraform apply` must be run after setting this to `false` before `terraform destroy` will work."
}
