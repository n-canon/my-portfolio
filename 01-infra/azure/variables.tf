variable "location" {
  description = "Ressources location"
  type        = string
  default = "West Europe"
}

variable "environment" {
  description = "Environment of creation of the ressources"
  type        = string
  default = "dvp"
}


variable "project_name" {
  description = "Name of the project"
  type        = string
  default = "nca-project"
}


variable "ad_admin_group" {
  description = "Name of admin group"
  type        = string
  default = "az-developers-dvp"
}


variable "sql_admin_user" {
  description = "Username of SQL database Admin user"
  type        = string
  default = "sa_poc_test"
}

variable "sql_admin_password" {
  description = "Password of SQL database Admin user"
  type        = string
  default = "test"
}
