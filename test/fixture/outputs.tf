output "appServiceEndpoint" {
  value = "${module.terraform-azurerm-eventgrid-blob.appServiceEndpoint}"
}

output storageAccountEndpoint {
  value = "${module.terraform-azurerm-eventgrid-blob.storageAccountEndpoint}"
}
