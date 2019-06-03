output "appServiceEndpoint" {
  value = "${azurerm_template_deployment.arm.outputs["appServiceEndpoint"]}"
}

output storageAccountEndpoint {
  value = "${azurerm_storage_account.sa.primary_blob_endpoint}"
}