#!/bin/bash
set -e

PROJECT="cloud-resume-gcp-478116"
REGION="us-central1"

echo "🧹 Starting cleanup for API Gateway + Cloud Function..."

# --- API Gateway ---
echo "▶ Deleting API Gateway gateway..."
gcloud api-gateway gateways delete resume-gateway \
    --location=$REGION --project=$PROJECT --quiet || true

echo "▶ Deleting API Gateway config..."
gcloud api-gateway api-configs delete visitor-api-config \
    --api=resume-api --project=$PROJECT --quiet || true

echo "▶ Deleting API Gateway API..."
gcloud api-gateway apis delete resume-api \
    --project=$PROJECT --quiet || true

# --- Cloud Function ---
echo "▶ Deleting Cloud Function..."
gcloud functions delete visitor-counter \
    --region=$REGION --project=$PROJECT --quiet || true

# --- Buckets ---
echo "▶ Deleting Cloud Function bucket..."
gsutil rm -r gs://${PROJECT}-function-bucket || true

echo "Cleanup complete!"
