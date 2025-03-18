variable "location" {
  description = "Ressources location"
  type        = string
}

variable "environment" {
  description = "Environment of creation of the ressources"
  type        = string
}


variable "project_name" {
  description = "Name of the project"
  type        = string
}


variable "ad_admin_group" {
  description = "Name of admin group"
  type        = string
}


variable "sql_admin_user" {
  description = "Username of SQL database Admin user"
  type        = string
}

variable "sql_admin_password" {
  description = "Password of SQL database Admin user"
  type        = string
}

variable "developers_group" {
  description = "Developer group"
  type        = string
}
