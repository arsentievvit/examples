variable "yandex_folder_id" {
  description = "Example variable"
}

variable "service_account_key_file" {
  description = "JSON ключ для доступа сервисного аккаунта editor в необходимом каталоге"
  type = string
}

variable "folder_id" {
  description = "Дефолтный каталог для работы terraform в облаке"
}
