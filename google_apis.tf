locals {
  services = {
    iam = "iam.googleapis.com"
  }
}


resource "google_project_service" "services" {
  for_each           = local.services
  project            = var.google_cloud_project_id
  service            = each.value
  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
}
