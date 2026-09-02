
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "7664be55-774e-45fd-a02c-40627b5a7a58" # Id de suscripción
}
