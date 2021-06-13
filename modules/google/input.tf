variable "name"             { type = string }
variable "zone"             { type = string }
variable "keypair_path"     { type = string }
variable "machine_type"     { type = string }
variable "image_name"       { type = string }
variable "boot_disk_size"   { type = string }
variable "init_script_path" {
  type = string
  default = null
}
