# Configures Azure as the Terraform provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Specifies provider-level settings (leaving default settings here)
provider "azurerm" {
  features {}
}

# Create a Resource Group (a logical container for all Azure resources)
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-analytics"
  location = var.location
}

# Create the SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = "sql-${var.project_name}-server"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

# Create the SQL Database inside the server
resource "azurerm_mssql_database" "sql_db" {
  name      = "db-${var.project_name}-data"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "S0" # This is a basic, low-cost tier perfect for this project ($15/month)
}

# Create a firewall rule to allow only your computer to access the database
resource "azurerm_mssql_firewall_rule" "my_ip_rule" {
  name             = "AllowMyIP"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = chomp(data.http.my_ip.response_body)
  end_ip_address   = chomp(data.http.my_ip.response_body)
}

# Helper function to get your current public IP address
data "http" "my_ip" {
  url = "http://ifconfig.me"
}