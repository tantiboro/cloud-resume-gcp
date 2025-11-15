resource "google_project_service" "storage_api" {
  service = "storage.googleapis.com"
}

resource "google_storage_bucket" "resume_bucket" {
  name          = "${var.gcp_project_id}-resume-site"
  location      = var.gcp_region
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_binding" "public" {
  bucket = google_storage_bucket.resume_bucket.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  bucket = google_storage_bucket.resume_bucket.name
  source = "../frontend/index.html"
}
