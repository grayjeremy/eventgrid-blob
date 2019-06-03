
resource "azurerm_resource_group" "rg" {
  name     = "${var.resourceGroupName}"
  location = "${var.defaultLocation}"
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.storageAccountName}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  account_kind             = "BlobStorage"
}

resource "azurerm_storage_container" "sc" {
  name                  = "uploads"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  storage_account_name  = "${azurerm_storage_account.sa.name}"
  container_access_type = "private"
}
data "http" "eg-view" {
  url = "${var.armTemplateUrl}"
}

resource "azurerm_template_deployment" "arm" {
  name                = "acctesttemplate-01"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  parameters = {
    "siteName"        = "${var.siteName}",
    "hostingPlanName" = "${var.hostingPlanName}"
  }

  deployment_mode = "Incremental"
  template_body   = <<DEPLOY
    ${data.http.eg-view.body}
  DEPLOY

}

resource "azurerm_eventgrid_event_subscription" "eg" {
  name = "defaultEventSubscription"
  scope = "${azurerm_storage_account.sa.id}"
  webhook_endpoint {
    url = "${azurerm_template_deployment.arm.outputs["appServiceEndpoint"]}/api/updates"
  }
}
