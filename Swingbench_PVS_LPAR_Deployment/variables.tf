
variable "vm_name" {
  description = "AIX LPAR Name"
  default = "demo-VM4"
}

variable "image_id_username" {
  description = "The username to SSH into image ID"
}

variable "image_id_password" {
  description = "The password of the username to SSH into image ID"
}

variable "ibmcloud_api_key" {
    description = "Denotes the IBM Cloud API key to use"
}

variable "ibmcloud_region" {
    description = "Denotes which IBM Cloud region to connect to"
    default     = "eu-de"
}

variable "ibmcloud_zone" {
    description = "Denotes the zone within the region to connect to (only needed for multi-zone regions--e.g., eu-de-1)"
    default     = "eu-de-1"
}

variable "power_instance_id" {
    description = "Power Virtual Server instance ID associated with your IBM Cloud account (note that this is NOT the API key)"
    default  =  "c7426567-d768-47ca-9741-7b4f4dbce4ae"
}

variable "memory" {
    description = "Amount of memory (GB) to be allocated to the VM"
    default     = "8"
}

variable "processors" {
    description = "Number of virtual processors to allocate to the VM"
    default     = "0.5"
}

variable "proc_type" {
    description = "Processor type for the LPAR - shared/dedicated"
    default     = "shared"
}

variable "ssh_key_name" {
    description = "SSH key name in IBM Cloud to be used for SSH logins"
    default = "testkey"
}

variable "shareable" {
    description = "Should the data volume be shared or not - true/false"
    default     = "true"
}

variable "networks" {
    description = "List of networks that should be attached to the VM"
    default     = ["publicvlan"]
}

variable "system_type" {
    description = "Type of system on which the VM should be created - s922/e880"
    default     = "s922"
}

#variable "migratable" {
#    description = "Can the VM be migrated - true/false"
#    default     = "true"
#}

variable "image_name" {
    description = "Name of the AIX Image to Deploy"
    default = "7100-05-04"
}

variable "replication_policy" {
    description = "Replication policy of the VM"
    default     = "none"
}

variable "replication_scheme" {
    description = "Replication scheme for the VM"
    default     = "suffix"
}

variable "replicants" {
    description = "Number of VM instances to deploy"
    default     = "1"
}

