terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
   }
}

provider "yandex" {
  #token    = var.yc_token
  service_account_key_file = "key.json"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  zone = var.zone
}