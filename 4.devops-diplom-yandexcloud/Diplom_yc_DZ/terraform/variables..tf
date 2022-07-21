# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "cloud_id" {
  type = string
  default = ""
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "folder_id" {
  type = string
  default = ""
}

# variable "yc_token" {
#    default = ""
# }

# процент гарантированного обеспечения CPU
variable "core_fraction" {
  type = number
  default = 20
}

# прерываемая ВМ
variable "preemptible" {
  type = bool
  default = true
}

variable "acme_server" {
  type = string
  default = "letsencrypttest"
  #default = "letsencrypt"
}

# Зона доступности A
variable "zone" {
  type = string
  default = "ru-central1-a"
}

#Зона доступности B
variable "zone2" {
  type = string
  default = "ru-central1-b"
}

variable "image_id" {
  type = string
  default = "fd80rnhvc47031anomed"
}

variable "subnet1" {
  type = tuple([string])
  default = (["192.168.100.0/24"])
}

variable "subnet2" {
  type = tuple([string])
  default = (["192.168.101.0/24"])
}

variable "dns_ttl" {
  type = number
  default = 60
}

variable "mydomain" {
  type = string  
  default = "dmitryzakharov.website"
}
