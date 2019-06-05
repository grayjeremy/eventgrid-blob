output "appServiceEndpoint" {
  value = "${module.eventgrid-blob.appServiceEndpoint}"
}

output storageAccountEndpoint {
  value = "${module.eventgrid-blob.storageAccountEndpoint}"
}
