/* need to create a tfvars file */

variable "resourceGroupName" {
  description = "The name of the resource group"
  default     = "terraform-event-grid"
}

variable "defaultLocation" {
  description = "region name"
  default     = "eastus"
}

variable "storageAccountName" {
  default     = "yomrdj132428"
}

variable "siteName" {
  default = "jeremysweetsite45678"
}

variable "hostingPlanName" {
  default = "viewerhost"
}
