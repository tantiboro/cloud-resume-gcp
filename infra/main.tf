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

terraform {
  required_version = ">= 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.50"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.50"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
    }
  }

  backend "gcs" {
    bucket = "cloud-resume-gcp-478116-terraform-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "archive" {}
