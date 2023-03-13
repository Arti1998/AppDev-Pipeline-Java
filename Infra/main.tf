terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.93.0"
      
    } 
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

module "dockervm" {
  source    = "./modules/dockervm"
  
}

module "acr" {
  source    = "./modules/acr"
 }





