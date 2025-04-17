# STATIC BUCKET
###############
# Static bucket for long term cacheable application assets (eg favicons, logo images etc).

resource "google_storage_bucket" "static_assets" {
  name                        = "${var.resource_affix}--static-assets--${var.environment}"
  location                    = "EU"
  force_destroy               = !var.deletion_protection
  uniform_bucket_level_access = true
  labels                      = {}
  cors {
    origin          = ["*"]
    method          = ["GET"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}


# Make static bucket contents public.
resource "google_storage_bucket_iam_member" "static_assets_object_viewer" {
  bucket = google_storage_bucket.static_assets.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}


# Allow the server to administer what's on the static bucket.
resource "google_storage_bucket_iam_member" "static_assets_object_admin" {
  for_each = toset(
    [
      "serviceAccount:${var.server_service_account_email}",
      "serviceAccount:${var.github_actions_service_account_email}"
    ]
  )
  bucket = google_storage_bucket.static_assets.name
  role   = "roles/storage.objectAdmin"
  member = each.value
}


# PRIVATE BUCKET
################
# Private bucket for user-editable assets. Note: CORS are set to allow direct uploads, enabling upload of files larger
# than 32 mb (Cloud Run has a hard limit on file upload size).

resource "google_storage_bucket" "private_assets" {
  name                        = "${var.resource_affix}--private-assets--${var.environment}"
  labels                      = {}
  location                    = "EU"
  force_destroy               = !var.deletion_protection
  uniform_bucket_level_access = false

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}


resource "google_storage_bucket_iam_member" "private_assets_object_admin" {
  bucket = google_storage_bucket.private_assets.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.server_service_account_email}"
}


# PUBLIC BUCKET (OPTIONAL)
##########################
resource "google_storage_bucket" "public_assets" {
  count                       = var.create_public_bucket ? 1 : 0
  name                        = "${var.resource_affix}--public-assets--${var.environment}"
  location                    = "EU"
  force_destroy               = !var.deletion_protection
  uniform_bucket_level_access = true
  labels                      = {}
  cors {
    origin          = ["*"]
    method          = ["GET"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}


# Make public bucket contents public.
resource "google_storage_bucket_iam_member" "public_assets_object_viewer" {
  count  = var.create_public_bucket ? 1 : 0
  bucket = google_storage_bucket.public_assets[0].name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}


# Allow the server to administer what's on the public bucket.
resource "google_storage_bucket_iam_member" "public_assets_object_admin" {
  count  = var.create_public_bucket ? 1 : 0
  bucket = google_storage_bucket.public_assets[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.server_service_account_email}"
}
