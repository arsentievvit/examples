variable "folder_id" {
  description = "Example variable"
}

variable "service_account_key_file" {
  description = "JSON ключ для доступа сервисного аккаунта editor в необходимом каталоге"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "Дефолтный каталог для работы terraform в облаке"
  sensitive   = true
}

variable "zone" {
  description = "Default zone"
}

variable "ssh_key_file" {
  default = null
}

variable "ssh_private_key_file" {
  default = null
}
