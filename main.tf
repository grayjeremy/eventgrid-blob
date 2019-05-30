
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
  account_kind = "BlobStorage"
  
}

resource "azurerm_storage_container" "sc" {
  name                  = "uploads"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  storage_account_name  = "${azurerm_storage_account.sa.name}"
  container_access_type = "private"
}

resource "azurerm_template_deployment" "arm" {
  name                = "acctesttemplate-01" /* randomize this */
  resource_group_name = "${azurerm_resource_group.rg.name}"

  parameters = {
    "siteName" = "${var.siteName}",
    "hostingPlanName" = "${var.hostingPlanName}"
  }

  deployment_mode = "Incremental"
  template_body = <<DEPLOY
  {
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
      "siteName": {
        "type": "string",
        "metadata": {
          "description": "The name of the web app that you wish to create."
        }
      },
      "hostingPlanName": {
        "type": "string",
        "metadata": {
          "description": "The name of the App Service plan to use for hosting the web app."
        }
      },
      "sku": {
        "type": "string",
        "allowedValues": [
          "F1",
          "D1",
          "B1",
          "B2",
          "B3",
          "S1"
        ],
        "defaultValue": "F1",
        "metadata": {
          "description": "The pricing tier for the hosting plan."
        }
      },
      "repoURL": {
        "type": "string",
        "defaultValue": "https://github.com/Azure-Samples/azure-event-grid-viewer.git",
        "metadata": {
          "description": "The URL for the GitHub repository that contains the project to deploy."
        }
      },
      "branch": {
        "type": "string",
        "defaultValue": "master",
        "metadata": {
          "description": "The branch of the GitHub repository to use."
        }
      },
      "location": {
        "type": "string",
        "defaultValue": "[resourceGroup().location]",
        "metadata": {
          "description": "Location for all resources."
        }
      }
    },
    "resources": [
      {
        "apiVersion": "2015-08-01",
        "name": "[parameters('hostingPlanName')]",
        "type": "Microsoft.Web/serverfarms",
        "location": "[parameters('location')]",
        "sku": {
          "name": "[parameters('sku')]",
          "capacity": "0"
        },
        "properties": {
          "name": "[parameters('hostingPlanName')]"
        }
      },
      {
        "apiVersion": "2015-08-01",
        "name": "[parameters('siteName')]",
        "type": "Microsoft.Web/sites",
        "location": "[parameters('location')]",
        "dependsOn": [
          "[resourceId('Microsoft.Web/serverfarms', parameters('hostingPlanName'))]"
        ],
        "properties": {
          "serverFarmId": "[parameters('hostingPlanName')]",
          "siteConfig": {
                "webSocketsEnabled": true
          }          
        },
        "resources": [
          {
            "apiVersion": "2015-08-01",
            "name": "web",
            "type": "sourcecontrols",
            "dependsOn": [
              "[resourceId('Microsoft.Web/Sites', parameters('siteName'))]"
            ],
            "properties": {
              "RepoUrl": "[parameters('repoURL')]",
              "branch": "[parameters('branch')]",
              "IsManualIntegration": true
            }
          }
        ]
      }
    ],
    "outputs": {
        "appServiceEndpoint": {
            "type": "string",
            "value": "[concat('https://',reference(resourceId('Microsoft.Web/sites', parameters('siteName'))).hostNames[0])]"
        }
    }

  }
  DEPLOY
  
  
  }

resource "azurerm_eventgrid_event_subscription" "eg" {
  name  = "defaultEventSubscription"
  scope = "${azurerm_storage_account.sa.id}"
  webhook_endpoint {
    url = "${azurerm_template_deployment.arm.outputs["appServiceEndpoint"]}/api/updates"
  }
 
}
