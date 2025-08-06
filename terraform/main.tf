# Configures the required Terraform providers (in this case, only Azure)
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Specifies provider-level settings (we are using default settings here)
provider "azurerm" {
  features {}
}

# 1. Creates a Resource Group (a logical container for all our Azure resources)
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-analytics"
  location = var.location
}

# 2. Creates the SQL Server
# Note the name uses the project_name variable to ensure it's unique
resource "azurerm_mssql_server" "sql_server" {
  name                         = "sql-${var.project_name}-server"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

# 3. Creates the SQL Database inside the server
resource "azurerm_mssql_database" "sql_db" {
  name      = "db-${var.project_name}-data"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "S0" # This is a basic, low-cost tier perfect for this project ($15/month)
}

# 4. CRITICAL: Creates a firewall rule to allow YOUR computer to access the database
# By default, the database is locked down. This rule finds your public IP and adds it.
resource "azurerm_mssql_firewall_rule" "my_ip_rule" {
  name             = "AllowMyIP"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = chomp(data.http.my_ip.response_body)
  end_ip_address   = chomp(data.http.my_ip.response_body)
}

# Helper to get your current public IP address
data "http" "my_ip" {
  url = "http://ifconfig.me"
}