output "de_ips" {
  description = "De IPv4 address"
  value = {
    for server in hcloud_server.de_node :
    server.name => server.ipv4_address
  }
}

output "fi_ips" {
  description = "Fi IPv4 address"
  value = {
    for server in hcloud_server.fi_node :
    server.name => server.ipv4_address
  }
}

output "us_ips" {
  description = "US IPv4 address"
  value = {
    for server in hcloud_server.us_node :
    server.name => server.ipv4_address
  }
}