variable "location" {
  type        = string
  description = "Default location for all resources."
  default     = "westeurope"
}

variable "admin_username" {
  type        = string
  description = "Default admin username for all VMs."
  default     = "customerAdmin"
}

variable "admin_password" {
  type        = string
  description = "Default admin password for all VMs."
  sensitive   = true
}
