module "google" {
  source = "./modules/google"

  for_each = var.google_module

  name             = each.key
  zone             = each.value.zone
  keypair_path     = each.value.keypair_path
  machine_type     = each.value.machine_type
  image_name       = each.value.image_name
  boot_disk_size   = each.value.boot_disk_size
  init_script_path = lookup(each.value, "init_script_path", null)
}
