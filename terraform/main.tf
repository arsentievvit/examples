data "yandex_compute_image" "def-ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
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
    subnet_id = var.subnet_id
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.def-ubuntu.id
      size     = "10"
      type     = "network-hdd"
    }
  }
}

resource "yandex_compute_instance" "app" {
  count       = 2
  name        = "reddit-app-${count.index}"
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
    subnet_id = var.subnet_id
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = "15"
      type     = "network-hdd"
    }
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
  connection {
    bastion_host        = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
    bastion_port        = 22
    bastion_user        = "ubuntu"
    bastion_private_key = file(var.ssh_key_private_file)

    type        = "ssh"
    user        = "ubuntu"
    host        = self.network_interface[0].ip_address
    agent       = false
    private_key = file(var.ssh_key_private_file)
  }
}
