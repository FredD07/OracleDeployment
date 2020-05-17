################################################################
# Module to send email to recipents when deployment is done
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

provider "openstack" {
  insecure = true
  version  = "~> 0.3"
}

variable "vm_recipient_email_address" {
  description = "The email of the recipient."
}

variable "vm_ipaddress_to_ssh_to" {
  description = "The ip of the VM to connect to."
}

variable "user" {
  description = "user to connect"
}

variable "user_password" {
    description = "User password"
}

variable "asm_home" {
    description = "Oracle ASM Home Path"
}

variable "oracle_home" {
    description = "Oracle ASM Home Path"
}

variable "asm_password" {
    description = "ASM Instance Password"
}
  
variable "db_sid" {
    description = "Database SID"
}
 
variable "db_password" {
    description = "Database Instance Password"
}   
 
     
# virtual Machine 
resource "null_resource" "SendeMailforOracleVM" {
# Specify the connection

 connection {
    type     = "ssh"
    host     = "${var.vm_ipaddress_to_ssh_to}"
    user     = "${var.user}"
    password = "${var.user_password}"
    timeout  = "45m"
  }
  
  # remote execution of the script  
  provisioner "remote-exec" {
    inline = [
      "bash /home/GBS-Digital-Platform/automation/mail/emailing.sh \"${var.vm_recipient_email_address}\" ${var.vm_ipaddress_to_ssh_to} ${var.vm_service_name} ${var.vm_HANA_backup_to_use} ${var.vm_isNatted}",
    ]
  }
 
}
