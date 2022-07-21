
resource "yandex_vpc_network" "mynetwork" {
  name = "mynetwork"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = var.zone
  network_id     = yandex_vpc_network.mynetwork.id
  v4_cidr_blocks = var.subnet1
}

resource "yandex_vpc_subnet" "subnet2" {
  name           = "subnet2"
  zone           = var.zone2
  network_id     = yandex_vpc_network.mynetwork.id
  v4_cidr_blocks = var.subnet2
}
