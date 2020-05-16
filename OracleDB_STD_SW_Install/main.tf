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

variable "location" {
  description = "Location of Oracle SW Location for download .ie NFS Server or IBM Cloud Object Storage"
}

#Variable : Oracle Database Details for Installation 
variable "db_version" {
  description = "Database Version to install"
}

variable "OracleHome" {
  description = "Oracle Home Path to install Oracle DB "
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
    destination = "/tmp/OracleDBInstall.sh"
    content     = <<EOF

#!/bin/ksh

if (( $# != 2 )); then
    echo "usage: arg 1 is db version, arg 2 is oracle home"
    exit -1
fi

version=$1
oracle_home=$2
oraclebase="/u01/oracle/database"

if [ "$oracle_home" = "/u01/oracle/db_version/db_home" ]; then
    oracle_home=`echo $oracle_home | sed -e "s/db_version/$version/g"`
fi;

#Create Oracle HOME if it does not exist 
if [ ! -d "$oracle_home" ]; then
 mkdir -p $oracle_home
 mkdir -p $oraclebase
 chown -R oracle:oinstall $oracle_home
 chown -R oracle:oinstall $oraclebase
fi

chown oracle:oinstall /u01/app/oraInventory

if [ "${var.location}" = "NFS Server" ]; then
	#Mount Oracle Binaries FileSystems
	nfso -o nfs_use_reserved_ports=1
	mount 10.7.33.2:/export/Oracle/ /stage
	su - oracle <<EOR
	cd $oracle_home
	unzip -oq /stage/database/$version/*.zip
EOR
else
        echo "Downloading Oracle Software from IBM Cloud Object Storage"
	COSDate=`/opt/freeware/bin/date -u  +"%m%d%H%M" -d "$(curl -I 'https://s3.eu-de.cloud-object-storage.appdomain.cloud/' 2>/dev/null | grep -i '^date:' | sed 's/^[Dd]ate: //g')"`; date -n -u $COSDate;
        for i in `/opt/freeware/bin/aws --endpoint-url="https://s3.eu-de.cloud-object-storage.appdomain.cloud" s3 ls s3://bucket-orademo/database/19c/  | tr -s ' ' | cut -d ' ' -f4- | grep "\.zip$"`
        do
        echo " aws --endpoint-url="https://s3.eu-de.cloud-object-storage.appdomain.cloud" s3 sync s3://bucket-orademo/database/19c/$i  $oracle_home"
        /opt/freeware/bin/aws --endpoint-url="https://s3.eu-de.cloud-object-storage.appdomain.cloud" s3 cp  s3://bucket-orademo/database/19c/$i  $oracle_home
        done
        su - oracle <<EOR
        cd $oracle_home
        unzip -oq *.zip
EOR
fi


#Installation Binaire Oracle Database

su - oracle <<EOT
##########Test Install 18c
echo "export ORACLE_HOME=$oracle_home" >> .profile
echo "export PATH=$oracle_home/bin:\$PATH" >> .profile

. .profile

##################

cd $oracle_home

./runInstaller -ignorePrereq  -force -waitforcompletion -silent                        \
    -responseFile $oracle_home/install/response/db_install.rsp               \
    oracle.install.option=INSTALL_DB_SWONLY                                    \
    UNIX_GROUP_NAME=oinstall                                                   \
    SELECTED_LANGUAGES=en,en_GB                                                \
    ORACLE_BASE=$oraclebase                                                 \
    oracle.install.db.InstallEdition=EE                                        \
    oracle.install.db.OSDBA_GROUP=dba                                          \
    oracle.install.db.OSBACKUPDBA_GROUP=dba                                    \
    oracle.install.db.OSDGDBA_GROUP=dba                                        \
    oracle.install.db.OSKMDBA_GROUP=dba                                        \
    oracle.install.db.OSRACDBA_GROUP=dba                                       \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
    DECLINE_SECURITY_UPDATES=true <<EOG
y
EOG

EOT
$oracle_home/root.sh

if [ "${var.asm_home}" = "NFS Server" ]; then
umount /stage
fi

EOF
}

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "bash -c 'chmod +x /tmp/OracleDBInstall.sh'",
      "bash -c '/tmp/OracleDBInstall.sh \"${var.db_version}\" \"${var.OracleHome}\">> OracleDBInstall.log 2>&1'"
    ]
  }
  
  provisioner "local-exec" {
  command = "echo '----Waiting for Oracle Database Binaries Completion----'",
  }
  
  provisioner "file" {
      destination = "/tmp/CheckInstallation.sh"
      content     = <<EOF
      
     #!/bin/ksh

    cpt=1
    while [ $cpt -eq 1 ]
    do
        ps -ef |grep -v grep | grep OracleDBInstall.sh
    if [ $? -eq 0 ]; then
        sleep 3
    else
        cpt=0
    fi
    done

    
    EOF
    }
    
    provisioner "remote-exec" {
    inline = [
      "bash -c 'chmod +x /tmp/CheckInstallation.sh'",
      "bash -c '/tmp/CheckInstallation.sh '"
    ]

  }

  
  


}

output "os-user-name" {
  value = "${var.image_id_username}"
}

output "os-user-password" {
  value = "${var.image_id_password}"
}
