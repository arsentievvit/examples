# Использование зеркала Яндекса для скачивания провайдера с зеркала

# nano ~/.terraformrc
# provider_installation {
#   network_mirror {
#     url = "https://terraform-mirror.yandexcloud.net/"
#     include = ["registry.terraform.io/*/*"]
#   }
#   direct {
#     exclude = ["registry.terraform.io/*/*"]
#   }
# }

# Блок terraform описывает используемые провайдеры
# в моём случае yandex, в котором указывается откуда его брать
# и его версию
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.96.1"
    }
  }
}

# В блоке provider.yandex указываются начальные значения
# для работы с Яндекс облаком

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}
