
variable "vm_name" {
  description = "AIX LPAR Name"
  default = "demo-VM1"
}

variable "asm_data_dg_disk" {
  description = "Number of ASM Data Diskgroup"
  default = 2
}

variable "asm_data_dg_size" {
  description = "Size of ASM Data Diskgroup"
  default = 10
}

variable "asm_data_type" {
  description = "Type of ASM DATA Storage (SSD/Standard)"
  default = "ssd"
}

variable "asm_reco_dg_disk" {
  description = "Number of ASM RECO Diskgroup"
  default = 2
}

variable "asm_reco_dg_size" {
  description = "Size of ASM RECO Diskgroup"
  default = 10
}

variable "asm_reco_type" {
  description = "Type of ASM RECO Storage (SSD/Standard)"
  default = "ssd"
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


variable "vm_private_key_base64" {
    description = "The base64-encoded form of the private key used to make SSH connections to the VM"
    default     = "LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUJGd0FBQUFkemMyZ3RjbgpOaEFBQUFBd0VBQVFBQUFRRUE2R1hDbkM4RW9MOUxGUURXbFR4TEYraGU5UGgveXk5cU5FSThDelh4TGpjZGZSWi9JNmwvCmk1cGxvTkRQZTdyYUtQOGNQb3RxK3YzeWduMjZBaVJURFZGZ3d6TFlpd3JhNTdENXZDeU1JVytsNjk1d1JrbkdxenkyRW8KMllsaFd2UWxsRDcvZUtieTgxVWtWa1kyenpZRE9STTBMZ21zd2FSRDh1OUR4bzZDeDd2a245TitFcG45c01ZMXRzaXhNQwo1VmMxZ3hlejZEd3pmVnlSOWFvUURTU3V4QUJwNjgwcGMrbTMrZ0NiYmlqSTArazg2SS9uQVhCNFJYNXpUNklKYXVzc3ZuCjM5OS9EcHBuVG9scjNIY1dHTXdaQWsxRXVYd0pTbzJHRTg3UjRSYjVqLzBVYWpucUhZRnlBT0hQemZkeENGdG1DTDZBYy8KKzRqanU4N0trd0FBQTlBNDdrNFFPTzVPRUFBQUFBZHpjMmd0Y25OaEFBQUJBUURvWmNLY0x3U2d2MHNWQU5hVlBFc1g2Rgo3MCtIL0xMMm8wUWp3TE5mRXVOeDE5Rm44anFYK0xtbVdnME05N3V0b28veHcraTJyNi9mS0NmYm9DSkZNTlVXRERNdGlMCkN0cm5zUG04TEl3aGI2WHIzbkJHU2NhclBMWVNqWmlXRmE5Q1dVUHY5NHB2THpWU1JXUmpiUE5nTTVFelF1Q2F6QnBFUHkKNzBQR2pvTEh1K1NmMDM0U21mMnd4alcyeUxFd0xsVnpXREY3UG9QRE45WEpIMXFoQU5KSzdFQUducnpTbHo2YmY2QUp0dQpLTWpUNlR6b2orY0JjSGhGZm5OUG9nbHE2eXkrZmYzMzhPbW1kT2lXdmNkeFlZekJrQ1RVUzVmQWxLallZVHp0SGhGdm1QCi9SUnFPZW9kZ1hJQTRjL045M0VJVzJZSXZvQnovN2lPTzd6c3FUQUFBQUF3RUFBUUFBQVFCNmp2L2M0aWJzcHpWdmRDdTIKTkQvZDhkdnlFUU5FSWxNK0VCZ2VTV3BSMXhza0ZyTWlHWWQ4RmdhMmtxaDVOZ2RMUzQ2WHBXcmJ4d1VYc0RwaVdzbTU0awpySFpvOHdkSjhSUlJIUEhTY2hrd0hMckZsRm1DNi9xNXJSbWY3NFY2TS91RmZOdTV3MEdvOWlQZG85WFAzVXBCMVZEVlhxCkRPMWxSSFQ4dE1jV2VTMlJUL3h6bEwwYTloVkR1VmhHZjQ4eUthU0xhdng5N29TeU9sOHZPd0haczRxdEdKb25PR0VYVWkKM2N3QmVtdXE2TkJkZVpWUDFGNy9nS01Pd0RLc29PRXVkdlBINFN3RnRQb0JiWUUzN1B2ZDEwbWtXb3RmY0dhMitJeWlVWgpZNlhNd3FSZ3YvSDRwY3Q0Qit1a1RqNitPVWRxcmRMazZBd29QZTV5RlVTeEFBQUFnUUM4WVlVOEplYk9OUjdVMHIvTURICm0rSm0vdnkveE0vZ1luUEYzSWV4WVFrcXBPclJyaEd2N09rZ3dEYk44QW82d0w0bkNXNVBwWVJjbTFvemQyZnRvYkU4TmcKTWY0c0ZMV2kwd1RZd0E4bHNZc2FzOThPL1Vwci9pYytieUhnWmxtTUZab2JkQkR6SytrdE5iOFZyaTBEU2ZwMGNodEpBZgpGNDJuMnBRdWpnVWdBQUFJRUEvOTNOb2N3WjdJUE9HWVlRZy9pNTVNekRFM3lwN0E0SzJWanVCQ3E1MVYzMXBPRUVTUnZZCkc3WDY2QnRxMjRONmFGUERDbHE0MmRhajZYNUxDM1dCVmVOT0NhZ3hCTVRVQ3JIRlR6MDBKSjYrRkJ2RkRBc1hKUEpueXEKaElSWDd1Z2N2cWFKS2tnWGszV2JLZEZPdFA3K2lqb2RoNk1yMExUWFJpWW5xSFIzY0FBQUNCQU9pRTBmK1Q0cnB6NDNmSwpuMXprWEFJd1JsYnV4a0FUV2pSUkZvaWdKMzM2bDE3YTArWW1meFo4QUZmTG8yUHVSMHE5dG80TkdqYWpyOEp5c2VLL2ZICjZNYzJ5eVZpMlNsZWFHbjJkbFY0T0tsK0M5NlpqSlBMOEkvNElIVVN2bnA1ckd4ZUo5UCtIQ28yU3RTRVNqelpmQUpBMXoKSzcxejl5OG95T3VIdkpURkFBQUFGV3AzWTNKdmNIQmxRR3AzWTNKdmNIQmxMVzFoWXdFQ0F3UUYKLS0tLS1FTkQgT1BFTlNTSCBQUklWQVRFIEtFWS0tLS0tCg=="
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
    default = "teskey"
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

variable "migratable" {
    description = "Can the VM be migrated - true/false"
    default     = "true"
}

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

resource "ibm_pi_volume" "asm_data_volume"{
  count = "${var.asm_data_dg_disk}"
  pi_volume_size       = "${var.asm_data_dg_size}"
  pi_volume_name       = "${var.vm_name}_${format("asm_data-%02d", count.index + 1)}"
  pi_volume_type       = "${var.asm_data_type}"
  pi_volume_shareable  = false
  pi_cloud_instance_id = "${var.power_instance_id}"
}

data "ibm_pi_network" "power_networks" {
    count                = "${length(var.networks)}"
    pi_network_name      = "${var.networks[count.index]}"
    pi_cloud_instance_id = "${var.power_instance_id}"
}

resource "ibm_pi_instance" "pvminstance" {
    pi_memory             = "${var.memory}"
    pi_processors         = "${var.processors}"
    pi_instance_name      = "${var.vm_name}"
    pi_proc_type          = "${var.proc_type}"
#    pi_migratable         = "${var.migratable}"
    pi_image_id           = "${data.ibm_pi_image.power_images.id}"
    pi_volume_ids         = ["${data.ibm_pi_volume.asm_data_volume.*.id}"]
    pi_network_ids        = ["${data.ibm_pi_network.power_networks.*.id}"]
    pi_key_pair_name      = "${var.ssh_key_name}"
    pi_sys_type           = "${var.system_type}"
    pi_replication_policy = "${var.replication_policy}"
    pi_replication_scheme = "${var.replication_scheme}"
    pi_replicants         = "${var.replicants}"
    pi_cloud_instance_id  = "${var.power_instance_id}"

}