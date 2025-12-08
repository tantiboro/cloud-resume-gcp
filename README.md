🚀 GCP Cloud Resume Challenge

This project defines, deploys, and manages a complete serverless technical resume solution on Google Cloud Platform (GCP) using Terraform. It includes a frontend hosted on Cloud Storage and a Python backend for a visitor counter.

🏗️ Project Architecture

This repository deploys the following key components on GCP:

Frontend Hosting: Google Cloud Storage (GCS) for hosting static assets (index.html, style.css).

Backend Logic: A Python-based Cloud Function (2nd Gen) that handles the visitor count logic and interacts with Firestore.

API Layer: An API Gateway providing a public, managed HTTPS endpoint for the Cloud Function.

Routing & Security: A Cloud Load Balancer with a Managed SSL Certificate to provide HTTPS and route traffic from a custom domain to the frontend bucket.

Database: Firestore (Native Mode) used to persist the visitor count data.

📁 Repository Structure

The project is organized to achieve a clean separation of application code, infrastructure definition, and deployment assets:

api/: Contains the backend Python source code (main.py) for the Cloud Function and its dependencies (requirements.txt).

frontend/: Contains the client-side static assets (index.html, style.css, main.js) for the public website.

infra/: Contains all Terraform configuration files (.tf, .tfvars, templates/). This is the execution directory for Terraform commands.

.build/: Temporary directory for generated artifacts (e.g., function.zip). This folder is ignored by Git.

.terraform/: Terraform cache and downloaded providers (ignored by Git).

scripts/: Utility shell scripts (e.g., cleanup.sh).

templates/: Configuration templates (e.g., api-spec.yaml.tpl).

⚙️ Getting Started

These instructions will get the infrastructure and application deployed on your GCP account.

Prerequisites

Install Terraform (Recommended version 1.x or later)

Install gcloud CLI

A configured GCP Project ID and service account credentials.

Deployment Steps

Navigate to the Infrastructure Directory:

cd infra


Initialize Terraform:
This downloads the necessary providers (Google, Google-Beta, Time) and connects to your remote state backend (GCS).

terraform init


Review the Plan:
This command generates an execution plan, showing exactly what Terraform will create, update, or destroy.

terraform plan -var-file="terraform.tfvars"


Apply the Configuration:
This command applies the changes to your GCP project, deploying the entire stack.

terraform apply -var-file="terraform.tfvars"


⚠️ Configuration Notes

Variables: Edit infra/terraform.tfvars to set your project ID, region, custom domain, and other critical variables.

Source Code Path: The Terraform files (e.g., visitor_backend.tf) reference the application code using the relative path source_dir = "../api".

Frontend Deployment: Frontend files are sourced from the frontend/ directory. If you make changes to index.html or style.css, run terraform apply to push the new versions to the GCS bucket.