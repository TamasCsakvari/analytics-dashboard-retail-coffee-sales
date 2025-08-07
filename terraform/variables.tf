variable "project_name" {
  description = "A short name for the project, used as a prefix for resources."
  type        = string
  default     = "coffeesales"
}

variable "location" {
  description = "The Azure region to deploy the resources in."
  type        = string
  default     = "West Europe"
}

variable "sql_admin_login" {
  description = "The administrator username for the SQL server."
  type        = string
  # No default, provided in .tfvars file
}
variable "sql_admin_password" {
  description = "The administrator password for the SQL server."
  type        = string
  sensitive   = true # This tells Terraform not to show the password in console output
}