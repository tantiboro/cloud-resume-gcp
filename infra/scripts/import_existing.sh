#!/bin/bash

PROJECT_ID="cloud-resume-gcp-478116"
REGION="us-central1"

echo "=== Terraform Import Script for Cloud Resume GCP ==="
echo "Project: $PROJECT_ID"
echo ""

# ------------------------------
# Helper to import only if exists
# ------------------------------
import_if_exists() {
    RESOURCE_NAME=$1
    IMPORT_CMD=$2
    CHECK_CMD=$3

    echo ""
    echo "--- Checking $RESOURCE_NAME ---"
    if eval "$CHECK_CMD" >/dev/null 2>&1; then
        echo "FOUND → Importing $RESOURCE_NAME"
        eval "$IMPORT_CMD"
    else
        echo "NOT FOUND → Skipping $RESOURCE_NAME"
    fi
}

# ------------------------------
# Storage Buckets
# ------------------------------
import_if_exists "function bucket" \
  "terraform import google_storage_bucket.function_bucket $PROJECT_ID-function-bucket" \
  "gsutil ls gs://$PROJECT_ID-function-bucket"

import_if_exists "resume website bucket" \
  "terraform import google_storage_bucket.resume_bucket $PROJECT_ID-resume-site" \
  "gsutil ls gs://$PROJECT_ID-resume-site"

# ------------------------------
# Firestore Database
# ------------------------------
import_if_exists "Firestore database" \
  "terraform import google_firestore_database.default projects/$PROJECT_ID/databases/\\(default\\)" \
  "gcloud firestore databases describe --project=$PROJECT_ID"

# ------------------------------
# Service Account
# ------------------------------
import_if_exists "Service Account resume-function-sa" \
  "terraform import google_service_account.function_sa projects/$PROJECT_ID/serviceAccounts/resume-function-sa@$PROJECT_ID.iam.gserviceaccount.com" \
  "gcloud iam service-accounts describe resume-function-sa@$PROJECT_ID.iam.gserviceaccount.com --project=$PROJECT_ID"

# ------------------------------
# Cloud Function (Cloud Run service)
# ------------------------------
import_if_exists "Cloud Function visitor-counter" \
  "terraform import google_cloudfunctions2_function.visitor_counter projects/$PROJECT_ID/locations/$REGION/functions/visitor-counter" \
  "gcloud functions describe visitor-counter --region=$REGION --project=$PROJECT_ID"

# ------------------------------
# Backend Bucket
# ------------------------------
import_if_exists "Backend Bucket" \
  "terraform import google_compute_backend_bucket.resume_backend projects/$PROJECT_ID/global/backendBuckets/resume-backend-bucket" \
  "gcloud compute backend-buckets describe resume-backend-bucket --global --project=$PROJECT_ID"

# ------------------------------
# NEG (Serverless NEG for Cloud Run)
# ------------------------------
import_if_exists "NEG visitor-counter-neg" \
  "terraform import google_compute_region_network_endpoint_group.visitor_neg projects/$PROJECT_ID/regions/$REGION/networkEndpointGroups/visitor-counter-neg" \
  "gcloud compute network-endpoint-groups describe visitor-counter-neg --region=$REGION --project=$PROJECT_ID"

# ------------------------------
# URL Map
# ------------------------------
import_if_exists "URL Map resume-url-map" \
  "terraform import google_compute_url_map.resume_url_map projects/$PROJECT_ID/global/urlMaps/resume-url-map" \
  'gcloud compute url-maps describe resume-url-map --project=$PROJECT_ID'

# ------------------------------
# Target HTTPS Proxy
# ------------------------------
import_if_exists "HTTPS Proxy resume-https-proxy" \
  "terraform import google_compute_target_https_proxy.resume_proxy projects/$PROJECT_ID/global/targetHttpsProxies/resume-https-proxy" \
  'gcloud compute target-https-proxies describe resume-https-proxy --project=$PROJECT_ID'

# ------------------------------
# Global Forwarding Rule
# ------------------------------
import_if_exists "Forwarding Rule resume-https-rule" \
  "terraform import google_compute_global_forwarding_rule.resume_https_rule projects/$PROJECT_ID/global/forwardingRules/resume-https-rule" \
  'gcloud compute forwarding-rules describe resume-https-rule --global --project=$PROJECT_ID'

# ------------------------------
# SSL Certificate
# ------------------------------
import_if_exists "Managed SSL Certificate resume-cert" \
  "terraform import google_compute_managed_ssl_certificate.resume_cert projects/$PROJECT_ID/global/sslCertificates/resume-cert" \
  "gcloud compute ssl-certificates describe resume-cert --project=$PROJECT_ID"

# ------------------------------
# IAM Binding
# ------------------------------
import_if_exists "Bucket IAM Binding (public)" \
  'terraform import google_storage_bucket_iam_binding.public "b/$PROJECT_ID-resume-site/roles/storage.objectViewer"' \
  "gsutil iam get gs://$PROJECT_ID-resume-site | grep storage.objectViewer"

echo ""
echo "=== DONE ==="
echo "Next steps:"
echo "  1) Run: terraform plan"
echo "  2) Run: terraform apply"
