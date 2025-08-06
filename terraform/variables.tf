# Defines a name for our project to be used in resource naming
variable "project_name" {
  description = "A short name for the project, used as a prefix for resources."
  type        = string
  default     = "coffeesales"
}

# Defines the Azure region where resources will be created
variable "location" {
  description = "The Azure region to deploy the resources in."
  type        = string
  default     = "West Europe" # You can change this to a region closer to you
}

# Defines the administrator username for the SQL server
variable "sql_admin_login" {
  description = "The administrator username for the SQL server."
  type        = string
  # No default, so we must provide this in our .tfvars file
}

# Defines the administrator password for the SQL server
variable "sql_admin_password" {
  description = "The administrator password for the SQL server."
  type        = string
  sensitive   = true # This tells Terraform not to show the password in console output
}