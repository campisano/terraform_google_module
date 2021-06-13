data "template_file" "init_script" {
  count = var.init_script_path != null ? 1 : 0

  template = file(var.init_script_path)
}

resource "google_compute_instance" "instance" {
  name         = var.name
  zone         = var.zone
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image_name
      size  = var.boot_disk_size
    }
  }

  metadata_startup_script = var.init_script_path == null ? null : data.template_file.init_script[0].rendered

  metadata = {
    ssh-keys = "root:${file(var.keypair_path)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}
