
resource "yandex_compute_instance" "nginx" {
  name = "nginx"
  hostname = "nginx"
  resources {
    core_fraction = var.core_fraction
    cores = 2
    memory = 2
  }
  scheduling_policy {
    preemptible = var.preemptible
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "db01" {
  name = "db01"
  hostname = "db01"
  zone = var.zone2
  resources {
    core_fraction = var.core_fraction
    cores = 4
    memory = 4
  }
  scheduling_policy {
    preemptible = var.preemptible
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet2.id
    nat       = false
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }

  depends_on = [
    yandex_vpc_subnet.subnet2
  ]
}

resource "yandex_compute_instance" "db02" {
  name = "db02"
  hostname = "db02"
  zone = var.zone2
  resources {
    core_fraction = var.core_fraction
    cores = 4
    memory = 4
  }
  scheduling_policy {
    preemptible = var.preemptible
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet2.id
    nat       = false
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "wordpress" {
  name = "app"
  hostname = "app"
  zone = var.zone2
  resources {
    core_fraction = var.core_fraction
    cores = 4
    memory = 4
  }
  scheduling_policy {
    preemptible = var.preemptible
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet2.id
    nat       = false
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "monitoring" {
  name = "monitoring"
  hostname = "monitoring"
  zone = var.zone2
  resources {
    core_fraction = var.core_fraction
    cores = 4
    memory = 4
  }
  scheduling_policy {
    preemptible = var.preemptible
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet2.id
    nat       = false
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "gitlab" {
  name = "gitlab"
  hostname = "gitlab"
  zone = var.zone2
  resources {
    core_fraction = var.core_fraction
    cores = 4
    memory = 4
  }
  scheduling_policy {
    preemptible = var.preemptible
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet2.id
    nat       = false
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "runner" {
  name = "runner"
  hostname = "runner"
  zone = var.zone2
  resources {
    core_fraction = var.core_fraction
    cores = 4
    memory = 4
  }
  scheduling_policy {
    preemptible = var.preemptible
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet2.id
    nat       = false
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
