provider "google" {
  region      = var.google_provider.region
  credentials = file(var.google_provider.credentials_file)
  project     = var.google_provider.project
}
