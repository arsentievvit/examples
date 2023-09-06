output "bastion_ip_address" {
  value = yandex_compute_instance.bhost.network_interface[0].nat_ip_address
}
