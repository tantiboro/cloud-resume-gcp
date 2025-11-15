# Reserve a global IP for the Load Balancer
resource "google_compute_global_address" "resume_ip" {
  name = "resume-lb-ip"
}

# Backend bucket connected to your static website bucket
resource "google_compute_backend_bucket" "resume_backend" {
  name        = "resume-backend-bucket"
  bucket_name = google_storage_bucket.resume_bucket.name
  enable_cdn  = true
}

# URL map routes all traffic to the backend bucket
resource "google_compute_url_map" "resume_url_map" {
  name    = "resume-url-map"
  project = var.gcp_project_id

  # Default = static website bucket
  default_service = google_compute_backend_bucket.resume_backend.id

  host_rule {
    hosts        = ["tantiboro.com", "www.tantiboro.com"]
    path_matcher = "static-routes"
  }

  path_matcher {
    name            = "static-routes"
    default_service = google_compute_backend_bucket.resume_backend.id
  }
}



# Managed SSL certificate
resource "google_compute_managed_ssl_certificate" "resume_cert" {
  name = "resume-cert"

  managed {
    domains = [
      var.domain_name,
      "www.${var.domain_name}"
    ]
  }
}

# HTTPS proxy that connects SSL cert to URL map
resource "google_compute_target_https_proxy" "resume_proxy" {
  name        = "resume-https-proxy"
  project     = var.gcp_project_id
  ssl_certificates = [google_compute_managed_ssl_certificate.resume_cert.id]
  url_map     = google_compute_url_map.resume_url_map.id
}


# Forwarding rule for HTTPS (port 443)
resource "google_compute_global_forwarding_rule" "resume_https_rule" {
  name       = "resume-https-rule"
  project    = var.gcp_project_id
  target     = google_compute_target_https_proxy.resume_proxy.id
  port_range = "443"
  ip_protocol = "TCP"
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_global_address.resume_ip.address
}


resource "google_compute_backend_service" "visitor_backend_service" {
  name                  = "visitor-backend-service"
  project               = var.gcp_project_id
  protocol              = "HTTP"
  timeout_sec           = 30
  enable_cdn            = false

  backend {
    group = google_compute_region_network_endpoint_group.visitor_neg.id
  }

  depends_on = [
    google_compute_region_network_endpoint_group.visitor_neg
  ]
}

