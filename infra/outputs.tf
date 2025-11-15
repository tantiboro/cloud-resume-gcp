output "bucket_url" {
  value = "http://storage.googleapis.com/${google_storage_bucket.resume_bucket.name}/index.html"
}

output "lb_ip" {
  value = google_compute_global_address.resume_ip.address
}

output "function_url" {
  value = google_cloudfunctions2_function.visitor_counter.service_config[0].uri
}

output "api_endpoint" {
  value = "https://tantiboro.com/api/counter"
}

# output "api_gateway_url" {
#   value = google_api_gateway_gateway.visitor_gateway.default_hostname
# }
