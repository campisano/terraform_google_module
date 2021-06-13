output "google_instances" {
  value = {for key, val in module.google : key => val.static_ip}
}
