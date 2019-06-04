module "eventgrid-blob" {
  source = "../../"

  resourceGroupName = "terraform-event-grid-test"
  defaultLocation = "eastus"
  storageAccountName = "yomrdj132428test"
  siteName = "jeremysweettestsite45678"
  hostingPlanName = "viewerhost"
  armTemplateUrl = "https://raw.githubusercontent.com/grayjeremy/azure-event-grid-viewer/add-output-variable/azuredeploy.json"
}