
[![Build Status](https://dev.azure.com/grayjeremy/terraform-azurerm-eventgrid-blob/_apis/build/status/grayjeremy.eventgrid-blob?branchName=master)](https://dev.azure.com/grayjeremy/terraform-azurerm-eventgrid-blob/_build/latest?definitionId=20&branchName=master)

# My new created Terraform module

This terraform module creates all the resouces described in [Quickstart: Route storage events to web endpoint with Azure CLI](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-event-quickstart?toc=%2fazure%2fevent-grid%2ftoc.json).  It creates an app service plan, an app service, and a blob storage account.

## Usage

```
module "terraform-azurerm-eventgrid-blob" {
  source = "github.com/grayjeremy/terraform-azurerm-eventgrid-blob.git"

  resourceGroupName = "terraform-event-grid"
  defaultLocation = "eastus"
  storageAccountName = "<...>"
  siteName = "<...>"
  hostingPlanName = "viewerhost"
  armTemplateUrl = "https://raw.githubusercontent.com/grayjeremy/azure-event-grid-viewer/add-output-variable/azuredeploy.json"
}
```

## Examples

Sample code in `examples` folder, there is only one scenario where this module works which is also listed under usage. 

## Inputs

resourceGroupName (required): This is the name of the resource group where you want the resources. 

defaultLocation (required): The region where all the resources live. 

storageAccountName (required): A globally unique name of a storage account

siteName (required): A globally unique name for an app service.  

hostingPlanName (required): The name of the hosting plan to create, this builds into the "Free" tier of app service plans. 

armTemplateUrl (required): This template references an external arm template that puts a custom image on the app service. 

## Outputs

appServiceEndpoint: This is the https hostname of the app service that is created.

storageAccountEndpoint:  This is the https hostname of the storage account that is created. 
