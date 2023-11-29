variable "hcloud_token" {

}

variable "de_datacenter" {
  default = "nbg1"
}

variable "fi_datacenter" {
  default = "hil1"
}

variable "us_datacenter" {
  default = "ash"
}

variable "de_server_type" {
  default = "cx21"
}

variable "fi_server_type" {
  default = "cx21"
}

variable "us_server_type" {
  default = "cpx21"
}

variable "de_instances" {
  default = "0"
}

variable "fi_instances" {
  default = "0"
}

variable "us_instances" {
  default = "0"
}

variable "os_type" {
  default = "ubuntu-22.04"
}

variable "ip_range" {
  default = "192.168.100.0/24"
}

variable "public_key_path" {
  default = "/path/of/public/key"
}