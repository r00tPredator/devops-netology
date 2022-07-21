resource "yandex_dns_zone" "zone1" {
  zone    = "${var.mydomain}."
  public  = true
}

resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "@"
  type    = "A"
  ttl     = var.dns_ttl
  data    = ["${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "rs2" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "www"
  type    = "A"
  ttl     = var.dns_ttl
  data    = ["${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "rs3" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "gitlab"
  type    = "A"
  ttl     = var.dns_ttl
  data    = ["${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "rs4" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "grafana"
  type    = "A"
  ttl     = var.dns_ttl
  data    = ["${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "rs5" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "prometheus"
  type    = "A"
  ttl     = var.dns_ttl
  data    = ["${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "rs6" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "alertmanager"
  type    = "A"
  ttl     = var.dns_ttl
  data    = ["${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}"]
}
