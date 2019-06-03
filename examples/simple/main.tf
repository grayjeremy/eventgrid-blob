module "eventgrid-blob" {
  source             = "github.com/grayjeremy/terraform-azurerm-eventgrid-blob.git"
  resourceGroupName  = "terraform-event-grid"
  defaultLocation    = "eastus"
  storageAccountName = "yomrdj132428"
  siteName           = "jeremysweetsite45678"
  hostingPlanName    = "viewerhost"
  armTemplateUrl     = "https://raw.githubusercontent.com/grayjeremy/azure-event-grid-viewer/add-output-variable/azuredeploy.json"
}
