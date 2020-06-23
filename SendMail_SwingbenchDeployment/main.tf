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

variable "vm_db_ipaddress_to_ssh_to" {
  description = "The ip of the Swingbench Apps VM to connect to."
}

variable "vm_apps_ipaddress_to_ssh_to" {
  description = "The ip of the SwingBench DB VM to connect to."
}

variable "user" {
  description = "user to connect"
}

variable "user_password" {
    description = "User password"
}

variable "swing_home" {
    description = "Path of Swingbench Application"
}

variable "oralce_home" {
    description = "Path of Oracle Database Home"
}

variable "db_sid" {
    description = "Database SID"
}
 
variable "db_password" {
    description = "Database Instance Password"
}   
 
variable "service_name" {
    description = "Name of Service"
}
     
 # virtual Machine 
resource "null_resource" "SendeMailforVMOracle" {
  # Specify the connection
  connection {
    type     = "ssh"
    host     = "10.3.44.11"
    user     = "root"
    password = "powerlinux"
  }

  provisioner "file" {
    source      = "templates"
    destination = "/tmp/"
  }
  
  provisioner "remote-exec" {
       inline = [
      "bash -c 'chmod +x /tmp/templates/emailing.sh'",
      "bash -c '/tmp/templates/emailing.sh ${var.vm_recipient_email_address} ${var.vm_db_ipaddress_to_ssh_to} ${var.vm_apps_ipaddress_to_ssh_to} ${var.user} ${var.user_password} ${var.swing_home} ${var.oracle_home} ${var.db_password} ${var.db_sid} \"${var.service_name}\"'"
    ]
    
  }
 
}

