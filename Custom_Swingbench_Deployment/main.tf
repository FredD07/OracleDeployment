################################################################
# Module to deploy a Single VM for deploying Oracle DB
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

variable "vm_db_ip_address" {
  description = "The IP address of the Database VM"
}

variable "vm_db_ip_int_address" {
  description = "The IP address of the Database VM"
}

variable "vm_apps_ip_address" {
  description = "The IP address of the Swingbench Application VM"
}

variable "vm_apps_ip_int_address" {
  description = "The IP address of the Swingbench Application VM"
}

variable "image_id_username" {
  description = "The username to SSH into image ID"
}

variable "image_id_password" {
  description = "The password of the username to SSH into image ID"
}

provider "openstack" {
  insecure = true
  version  = "~> 0.3"
}


resource "null_resource" "VMforOracleDB" {
 # Specify the ssh connection
  connection {
    type     = "ssh"
    host     = "${var.vm_db_ip_address}"
    user     = "${var.image_id_username}"
    password = "${var.image_id_password}"
    timeout  = "45m"
  }
  
 provisioner "file" {
    destination = "/tmp/CustomSwingbench.sh"
    content     = <<EOF

#!/bin/ksh

echo "Update /etc/hosts file on both APPS and DB LPARs"
#Update /etc/hosts on DB LPAR
HOST_DB_INT=${var.vm_db_ip_int_address}
HOST_DB_EXT=${var.vm_db_ip_address}

HOST_DB=`ssh -o "StrictHostKeyChecking no" $HOST_DB_INT hostname `
sleep 5
echo "$HOST_DB_INT $HOST_DB" >> /etc/hosts
echo "$HOST_DB_EXT $HOST_DB" >> /etc/hosts

HOST_APPS_INT=${var.vm_apps_ip_int_address}
HOST_APPS_EXT=${var.vm_apps_ip_address}

HOST_APPS=`ssh -o "StrictHostKeyChecking no" $HOST_APPS_INT hostname `
echo "$HOST_APPS_INT $HOST_APPS" >> /etc/hosts
echo "$HOST_APPS_EXT $HOST_APPS" >> /etc/hosts

scp -o "StrictHostKeyChecking no" /etc/hosts $HOST_APPS_INT:/etc/hosts

#Update Oracle Configuration according to IP Adresses and Hostnames (Listener.ora, Tnsnames.ora ...)
echo "**** Update Oracle DB Tier Configuration Files "
cd /u01
./set_env.sh $HOST_DB

echo "**** Update Swingbench Apps Tier Oracle Client "
ssh -o "StrictHostKeyChecking no" $HOST_APPS_INT  "/u01/set_env.sh $HOST_DB"

echo "**** Start Oracle Stack (Database, Listener ...)"
start_db.sh

EOF
}

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "bash -c 'chmod +x /tmp/CustomSwingbench.sh'",
      "bash -c '/tmp/CustomSwingbench.sh >> CustomSwingbench.log 2>&1'"
    ]
  }
}
  
  


output "os-user-name" {
  value = "${var.image_id_username}"
}

output "os-user-password" {
  value = "${var.image_id_password}"
}
