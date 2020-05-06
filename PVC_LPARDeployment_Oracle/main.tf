################################################################
# Module to deploy Single VM
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Licensed Materials - Property of IBM
#
# Copyright IBM Corp. 2017.
#
################################################################
variable "openstack_image_id" {
  description = "The ID of the image to be used for deploy operations."
}

variable "openstack_flavor_id" {
  description = "The ID of the flavor to be used for deploy operations."
}

variable "openstack_network_name" {
  description = "The name of the network to be used for deploy operations."
}

variable "image_id_username" {
  description = "The username to SSH into image ID"
}

variable "image_id_password" {
  description = "The password of the username to SSH into image ID"
}

variable "ibm_stack_name" {
  description = "Stack Name"
}

variable "asm_data_dg_disk" {
  description = "Number of ASM Data Diskgroup"
}

variable "asm_data_dg_size" {
  description = "Size of ASM Data Diskgroup"
}

variable "asm_reco_dg_disk" {
  description = "Number of ASM RECO Diskgroup"
}

variable "asm_reco_dg_size" {
  description = "Size of ASM RECO Diskgroup"
}

provider "openstack" {
  insecure = true
  #version  = "~> 0.3"
}

variable "number_of_instances" {}

resource "openstack_compute_instance_v2" "single-vm" {
  count     = "${var.number_of_instances}"
  name      = "${var.ibm_stack_name}${format("-%02d", count.index+1)}"
  image_id  = "${var.openstack_image_id}"
  flavor_id = "${var.openstack_flavor_id}"   

  network {
    name = "${var.openstack_network_name}"
  }

  # Specify the ssh connection
  connection {
    user     = "${var.image_id_username}"
    password = "${var.image_id_password}"
    timeout  = "10m"
  }
}

#Create and Attach Volumes for ASM DATA Diskgroup
resource "openstack_blockstorage_volume_v2" "asm_data_volumes" {
  count = "${var.asm_data_dg_disk}"
  name = "${var.vm_name}_${format("asm_data-%02d", count.index + 1)}"
  size =  "${var.asm_data_dg_size}"
}

resource "openstack_compute_volume_attach_v2" "asm_data_attachments" {
  count = "${var.asm_data_dg_disk}"
  instance_id  = "${openstack_compute_instance_v2.single-vm.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.asm_data_volumes.*.id[count.index]}"
}

#Create and Attach Volumes for ASM RECO Diskgroup
resource "openstack_blockstorage_volume_v2" "asm_reco_volumes" {
  count = "${var.asm_reco_dg_disk}"
  name = "${var.vm_name}_${format("asm_reco-%02d", count.index + 1)}"
  size =  "${var.asm_reco_dg_size}"
}

resource "openstack_compute_volume_attach_v2" "asm_reco_attachments" {
  count = "${var.asm_reco_dg_disk}"
  instance_id  = "${openstack_compute_instance_v2.single-vm.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.asm_reco_volumes.*.id[count.index]}"
}

#Create and Attach Volumes for ASM REPO Diskgroup
resource "openstack_blockstorage_volume_v2" "asm_repo_volumes" {
  count = 2
  name = "${var.vm_name}_${format("asm_repo-%02d", count.index + 1)}"
  size =  10
}

resource "openstack_compute_volume_attach_v2" "asm_repo_attachments" {
  count = 2
  instance_id  = "${openstack_compute_instance_v2.single-vm.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.asm_repo_volumes.*.id[count.index]}"
}


output "single-vm-ip" {
  value = "${openstack_compute_instance_v2.single-vm.network.0.fixed_ip_v4}"
}

output "single-vm-openstack_id" {
  value = "${openstack_compute_instance_v2.single-vm.id}"
}

output "os-user-name" {
  value = "${var.image_id_username}"
}

output "os-user-password" {
  value = "${var.image_id_password}"
}



