variable "ibmcloud_api_key" {
    description = "Denotes the IBM Cloud API key to use"
}

variable "ibmcloud_region" {
    description = "Denotes which IBM Cloud region to connect to"
    default     = "us-south"
}


variable "vm_name" {
    description = "Name of the VM"
}

variable "vm_private_key_base64" {
    description = "The base64-encoded form of the private key used to make SSH connections to the VM"
    default="LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUJGd0FBQUFkemMyZ3RjbgpOaEFBQUFBd0VBQVFBQUFRRUF0Nmp3MFpMSU9xYVdwV0VPWXdpLy9mM0dDVTNHOFJENHB6cHl3S1VTejNYUlVuOFBVZncvCktKR1NUdEZNVi9jRE8wTHZ3dU1BWDJWL3hRMHNIQXM4Y3BTUkl1TTkxV1MrNHR1V1BPOC9zNWtRRUFoMFJpVGxZR3htRW4KRXF0OE5ya0xweTNxZHlTcFlCeUdmMHJMc0RPWjk4U2oyTHpwUHMvc1VscGpWNE5QVzZVTVY3L3NVOXdLWjJodFFrUHd2OQpPbnk0M1R0cXg4MWRLOWZSVHdrUXdCcVcxUm14dHNLT1VRSHp5VzEySnJaWW5vVjhVajRMZWIxQkFLeERZb2J1L3djNTdPCi94S0w2aFFJUkVDYUtJd1Z4NnZhTjcwNVBneTZ2RjEvL2pCT05id25yYjFiSGhwMkxNSXBVR3hpSFJEem56eGJNR29lMzAKRGtDK1pDa3VmUUFBQStEVjRjQUYxZUhBQlFBQUFBZHpjMmd0Y25OaEFBQUJBUUMzcVBEUmtzZzZwcGFsWVE1akNMLzkvYwpZSlRjYnhFUGluT25MQXBSTFBkZEZTZnc5Ui9EOG9rWkpPMFV4WDl3TTdRdS9DNHdCZlpYL0ZEU3djQ3p4eWxKRWk0ejNWClpMN2kyNVk4N3orem1SQVFDSFJHSk9WZ2JHWVNjU3EzdzJ1UXVuTGVwM0pLbGdISVovU3N1d001bjN4S1BZdk9rK3oreFMKV21OWGcwOWJwUXhYdit4VDNBcG5hRzFDUS9DLzA2ZkxqZE8yckh6VjByMTlGUENSREFHcGJWR2JHMndvNVJBZlBKYlhZbQp0bGllaFh4U1BndDV2VUVBckVOaWh1Ny9Cem5zNy9Fb3ZxRkFoRVFKb29qQlhIcTlvM3ZUaytETHE4WFgvK01FNDF2Q2V0CnZWc2VHbllzd2lsUWJHSWRFUE9mUEZzd2FoN2ZRT1FMNWtLUzU5QUFBQUF3RUFBUUFBQVFBR3owN09sb0N5SEFjdDdxRlgKN3JVZnQ4OGwvU3BKT2ZYZVRYNS93aDhtYmhucTB5ZEFSUGdhaXZzL3pPYmx4QlRzbDVqSVF4NTZhd3NIeFd0RFJ1OWcyRAoxaGE4ZVpKL2tqOUR4bjJmOGtxNkk2MWZWcHZHaDg0TWdRR3Y0WWZqaDR6MUQvREhwaVpabC9Vc3R4dENWMGQ0Tm1SVTN2CnhQQmVxZlN4YXY0Z0NJUlJuN293TWRMbzg0NU9oWHk4YkRnbU9YQldGTVR6bVk4ajlxbVpEWlljTU5BOG40bnBuZnB1UXoKQStETHFnMUJnaDZYQml1OTRMekZJcVE2bStCK0VUYjJxV3c1U3NnZFIweG55NkdvMnM2WVNRdUFKcy9rUkdTTlZwNWlncAp3cDJDUkhxUXFYYTdLb3BQdnpMaGRUcy9aTC9sN1NQbnh2bytjYTUzeEZnSkFBQUFnUUMvZWwwMUhxenQrKzBkQWNlMS9SCnpvN0pnNXRubmlWRDZncWhXbFhhVU5qa1VjajJuNFVFOUhBWHBIRE0wY0FFUnQ1UDN2RGlSbDlwYXBJWU5PS0w1L0lnd0IKQnhRSnRhdm9RY2syWGk2TzZYY0o1UDFmd2ZKOW80dElhNGl6WnZQMlZBdGl6VGNpYzV3UmJkVTJnSFZjRWJ2RU0vQ0wyQgpMSGh2NDhLb1M4aXdBQUFJRUE3TWI0U1MzK2RFWlpCRVVmMEZJNUxuYU9nV0dvSVVzSXhmRlJhSVllVDZsVDZTYzBRWmlhCms4NGsyT2w4VjRRQ3pxYlRiUkxOV295RUpqVlhCcFN4MU44VVdUODU1eTVONVdqY2NtQXBQa2lFTit2cWRpWEhLKzZ3RUwKZzhhcTdYaGlMcGdNZ2xjU3BVeWh3TE8xMit2WGZ1c1hxbVNmZGJEdDZXUFpXZnR2OEFBQUNCQU1hU0E1UXF2blFRRDVRcgowRGZwV2dROGZueWtpNWZVSjRxakRZT1MybWhvYmlPNis3YzJaZXRRd2Q4ZHlRUHNYcnlJNmFjazNZcG5ZK0ZzSFdiRCtDCndiUXZEaUtFd2c4Z0IzZWlaTkRXK2NpYm1nL1piMHU0R2E2dUlpK0NOdTA2ZVpDWlBTVnNaak55WThVWGkralNSaGtOMUwKL20xWXVyY2FtcHJINjNhREFBQUFKRUpsYm05cGRESkFZV2x5TFdSbExXSmxibTlwZEM1dGIzQXVabkl1YVdKdExtTnZiUQpFQ0F3UUZCZz09Ci0tLS0tRU5EIE9QRU5TU0ggUFJJVkFURSBLRVktLS0tLQo=" 
}

variable "power_instance_id" {
    description = "Power Virtual Server instance ID associated with your IBM Cloud account (note that this is NOT the API key)"
    default= "f0f71cbe-7997-4924-8321-7f876a494973"
}

variable "memory" {
    description = "Amount of memory (GB) to be allocated to the VM"
    default     = "12"
}

variable "processors" {
    description = "Number of virtual processors to allocate to the VM"
    default     = "1"
}

variable "proc_type" {
    description = "Processor type for the LPAR - shared/dedicated"
    default     = "shared"
}

variable "ssh_key_name" {
    description = "SSH key name in IBM Cloud to be used for SSH logins"
    default="TEST"
}

variable "shareable" {
    description = "Should the data volume be shared or not - true/false"
    default     = "true"
}

variable "networks" {
    description = "List of networks that should be attached to the VM"
    default     = ["internal"]
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
    description = "Name of the image from which the VM should be deployed"
    default     = "IBMi-74-01-001"
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
