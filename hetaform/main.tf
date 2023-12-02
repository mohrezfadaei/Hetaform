resource "hcloud_ssh_key" "default" {
  name       = "hetafrom"
  public_key = file(var.public_key_path)
}

resource "hcloud_network" "eu_network" {
  name     = "eu_network"
  ip_range = "192.168.100.0/24"
}

resource "hcloud_network" "us_east_network" {
  name     = "us_east_network"
  ip_range = "192.168.200.0/24"
}

resource "hcloud_network_subnet" "eu_network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.eu_network.id
  network_zone = "eu-central"
  ip_range     = "192.168.100.0/24"
}

resource "hcloud_network_subnet" "us_east_network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.us_east_network.id
  network_zone = "us-east"
  ip_range     = "192.168.200.0/24"
}

resource "hcloud_server_network" "de_node_network" {
  count     = var.de_instances
  server_id = hcloud_server.de_node[count.index].id
  subnet_id = hcloud_network_subnet.eu_network_subnet.id
}

resource "hcloud_server_network" "fi_node_network" {
  count     = var.fi_instances
  server_id = hcloud_server.fi_node[count.index].id
  subnet_id = hcloud_network_subnet.eu_network_subnet.id
}

resource "hcloud_server_network" "us_node_network" {
  count     = var.us_instances
  server_id = hcloud_server.us_node[count.index].id
  subnet_id = hcloud_network_subnet.us_east_network_subnet.id
}

resource "hcloud_server" "de_node" {
  count       = var.de_instances
  name        = "${var.de_datacenter}-${var.de_server_type}-${count.index + 1}"
  image       = var.os_type
  server_type = var.de_server_type
  location    = var.de_datacenter
  ssh_keys    = [hcloud_ssh_key.default.id]
  labels = {
    key = "value"
  }
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  user_data = file("user_data.yml")
}

resource "hcloud_server" "fi_node" {
  count       = var.fi_instances
  name        = "${var.fi_datacenter}-${var.fi_server_type}-${count.index + 1}"
  image       = var.os_type
  server_type = var.fi_server_type
  location    = var.fi_datacenter
  ssh_keys    = [hcloud_ssh_key.default.id]
  labels = {
    key = "value"
  }
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  user_data = file("user_data.yml")
}

resource "hcloud_server" "us_node" {
  count       = var.us_instances
  name        = "${var.us_datacenter}-${var.us_server_type}-${count.index + 1}"
  image       = var.os_type
  server_type = var.us_server_type
  location    = var.us_datacenter
  ssh_keys    = [hcloud_ssh_key.default.id]
  labels = {
    key = "value"
  }
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  user_data = file("user_data.yml")
}

# Cloudflare Record
resource "cloudflare_record" "de_a_record" {
  count   = var.de_instances
  zone_id = var.cloudflare_zone_id
  name    = "${var.de_datacenter}-node${count.index + 1}"
  value   = hcloud_server.de_node[count.index].ipv4_address
  type    = "A"
}

resource "cloudflare_record" "fi_a_record" {
  count   = var.fi_instances
  zone_id = var.cloudflare_zone_id
  name    = "${var.fi_datacenter}-node${count.index + 1}"
  value   = hcloud_server.fi_node[count.index].ipv4_address
  type    = "A"
}

resource "cloudflare_record" "us_a_record" {
  count   = var.us_instances
  zone_id = var.cloudflare_zone_id
  name    = "${var.us_datacenter}-node${count.index + 1}"
  value   = hcloud_server.us_node[count.index].ipv4_address
  type    = "A"
}
