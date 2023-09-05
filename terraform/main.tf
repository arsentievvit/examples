resource "yandex_compute_image" "ubuntu" {
  source_family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "bhost" {
  name = "bastion-1"
  platform_id = "standard-v1"
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_file)}"
  }
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  network_interface {
    nat       = true
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "172.31.2.254"
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu.id
    }
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.network_interface[0].nat_ip_address
    agent       = false
    private_key = file(var.ssh_private_key_file)
  }
}

resource "yandex_compute_instance" "test-vm" {
  name = "test-vm"
  platform_id = "standard-v1"
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_file)}"
  }
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  network_interface {
    nat       = false
    subnet_id = yandex_vpc_subnet.internal.id
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu.id
    }
  }
  provisioner "remote-exec" {
    inline = ["sudo apt update -y && sudo apt upgrade -y"]
  }
  connection {
    bastion_host = yandex_compute_instance.bhost.network_interface[0].nat_ip_address
    bastion_user = "ubuntu"
    bastion_private_key = file(var.ssh_private_key_file)

    type        = "ssh"
    user        = "ubuntu"
    host        = self.network_interface[0].ip_address
    agent       = false
    private_key = file(var.ssh_private_key_file)
  }
}
