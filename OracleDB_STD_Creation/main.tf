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

##### Environment variables #####
#Variable : Virtual Machine Details 
variable "vm_ip_address" {
  description = "The IP address of the VM to deploy."
}

variable "image_id_username" {
  description = "The username to SSH into image ID"
}

variable "image_id_password" {
  description = "The password of the username to SSH into image ID"
}


#Variable : Oracle Database Details for Installation 
variable "db_sid" {
  description = "Database Oracle SID"
}

variable "ora_sys_password" {
  description = "Oracle Database Password "
}

variable "asm_sys_password" {
  description = "Oracle Database Password "
}

provider "openstack" {
  insecure = true
  version  = "~> 0.3"
}

# virtual Machine 
resource "null_resource" "VMforOracleDB" {
  # Specify the connection
  connection {
    type     = "ssh"
    host     = "${var.vm_ip_address}"
    user     = "${var.image_id_username}"
    password = "${var.image_id_password}"
    timeout  = "20m"
  }

provisioner "file" {
    destination = "/tmp/CreateDatabase.sh"
    content     = <<EOF

#!/bin/ksh
dbsid=$1
DBPWD=$2
ASMPWD=$3

su - oracle <<EOT

dbca -silent -createDatabase  \
-gdbName $dbsid					\
	    -templateName General_Purpose.dbc			\
            -characterSet WE8ISO8859P15				\
            -datafileDestination  +DATA/{DB_UNIQUE_NAME}/ 	\
            -sid $dbsid						\
            -systemPassword $DBPWD				\
            -sysPassword $DBPWD					\
            -createAsContainerDatabase false			\
            -recoveryAreaDestination +RECO/{DB_UNIQUE_NAME}/  	\
            -databaseType MULTIPURPOSE				\
            -storageType ASM 					\
            -asmsnmpPassword $ASMPWD				\
            -databaseConfigType SINGLE 				\
            -emConfiguration NONE	
            
echo "export ORACLE_SID=$dbsid >> .profile"
EOT
EOF
}

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "bash -c 'chmod +x /tmp/CreateDatabase.sh'",
      "bash -c '/tmp/CreateDatabase.sh \"${var.db_sid}\" \"${var.ora_sys_password}\" \"${var.asm_sys_password}\">> CreateDatabase.log 2>&1'"
    ]
  }
}

output "os-user-name" {
  value = "${var.image_id_username}"
}

output "os-user-password" {
  value = "${var.image_id_password}"
}
