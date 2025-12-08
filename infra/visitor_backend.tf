#########################################
# ENABLE REQUIRED APIs
#########################################

resource "google_project_service" "firestore_api" {
  project = var.gcp_project_id
  service = "firestore.googleapis.com"
}

resource "google_project_service" "cloudfunctions_api" {
  project = var.gcp_project_id
  service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "apigateway_api" {
  project = var.gcp_project_id
  service = "apigateway.googleapis.com"
}

#########################################
# FIRESTORE DATABASE
#########################################

resource "google_firestore_database" "default" {
  project     = var.gcp_project_id
  name        = "(default)"
  location_id = var.gcp_region
  type        = "FIRESTORE_NATIVE"
}

#########################################
# CLOUD FUNCTION SERVICE ACCOUNT + IAM
#########################################

resource "google_service_account" "function_sa" {
  account_id   = "resume-function-sa"
  display_name = "Resume Cloud Function Service Account"
}

resource "google_project_iam_binding" "firestore_access" {
  project = var.gcp_project_id
  role    = "roles/datastore.user"

  members = [
    "serviceAccount:${google_service_account.function_sa.email}"
  ]
}

#########################################
# PACKAGE CLOUD FUNCTION CODE
#########################################

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "../api" 
  output_path = ".build/function.zip"
}

#########################################
# FUNCTION DEPLOYMENT BUCKET
#########################################

resource "google_storage_bucket" "function_bucket" {
  name          = "${var.gcp_project_id}-function-bucket"
  location      = var.gcp_region
  force_destroy = true
}

resource "google_storage_bucket_object" "function_zip_object" {
  bucket = google_storage_bucket.function_bucket.name
  name   = "function.zip"
  source = data.archive_file.function_zip.output_path
}

#########################################
# CLOUD FUNCTION (GEN 2)
#########################################

resource "google_cloudfunctions2_function" "visitor_counter" {
  name     = "visitor-counter"
  location = var.gcp_region

  build_config {
    runtime     = "python311"
    entry_point = "visitor_counter"

    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.function_zip_object.name
      }
    }
  }

  service_config {
    service_account_email = google_service_account.function_sa.email
    timeout_seconds       = 10
  }

  depends_on = [
    google_project_service.cloudfunctions_api,
    google_project_service.firestore_api,
    google_project_service.cloudbuild_api # <<< required!
  ]
}

resource "google_project_service" "cloudbuild_api" {
  project = var.gcp_project_id
  service = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

# Serverless NEG linking Cloud Run service
resource "google_compute_region_network_endpoint_group" "visitor_neg" {
  name                  = "visitor-counter-neg"
  project               = var.gcp_project_id
  region                = var.gcp_region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = google_cloudfunctions2_function.visitor_counter.name
  }

  depends_on = [
    google_cloudfunctions2_function.visitor_counter
  ]
}


