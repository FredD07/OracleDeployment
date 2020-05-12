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

variable "vm_ip_address" {
  description = "The IP address of the VM to deploy."
}

variable "image_id_username" {
  description = "The username to SSH into image ID"
}

variable "image_id_password" {
  description = "The password of the username to SSH into image ID"
}

variable "asm_version" {
  description = "version of ASM/Grid Infrastructure"
}

variable "asm_home" {
  description = "Oracle ASM HOME Path"
}

variable "asm_password" {
  description = "ASM Instance Password"
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

variable "location" {
  description = "Location of Oracle SW Location for download .ie NFS Server or IBM Cloud Object Storage"
}

provider "openstack" {
  insecure = true
  version  = "~> 0.3"
}


resource "null_resource" "VMforOracleDB" {
 # Specify the ssh connection
  connection {
    type     = "ssh"
    host     = "${var.vm_ip_address}"
    user     = "${var.image_id_username}"
    password = "${var.image_id_password}"
    timeout  = "25m"
  }
  
 provisioner "file" {
    destination = "/tmp/PrepareASMDisk.sh"
    content     = <<EOF

#!/bin/ksh

# make iocp0 available
mkdev -l iocp0
# make iocp0 persistent
chdev -l iocp0 -P -a autoconfig='available'

sleep 20
cfgmgr

echo "nameserver 10.11.5.1" >> /etc/resolv.conf

IPADDR=`ifconfig -a|awk '/inet 127/ {next;}
                /inet / {print $2}'`
echo $IPADDR `hostname -s` >> /etc/hosts

#  FREEDISKS are those without PVID
#      then it is an ASM disk and this script will rendev/lkdev


#Configure ASM Disks for DATA Diskgroup
FREEDISKS=` lspv | grep hdisk | awk ' $2 == "none" { print $1 }'`
cpt=1

ASM_DATA_SIZE=$((${var.asm_data_dg_size}*1024))
echo "DATA Diskgroup Size Disk" $ASM_DATA_SIZE
for i in $FREEDISKS; do
        size=`getconf DISK_SIZE /dev/$i`
        if [[ ( $size -eq $ASM_DATA_SIZE ) && ( $cpt -le ${var.asm_data_dg_disk} ) ]]; then
        echo "replace $i by ASMDATA$cpt"
        rendev -l $i -n ASMDATA$cpt
        chown grid:oinstall /dev/ASMDATA$cpt /dev/rASMDATA$cpt
        chmod 660 /dev/ASMDATA$cpt /dev/rASMDATA$cpt
        lkdev -l ASMDATA$cpt -a -c ASM
        ((cpt=cpt+1))
    fi
done

#Configure ASM Disks for RECO Diskgroup
FREEDISKS=` lspv | grep hdisk | awk ' $2 == "none" { print $1 }'`
cpt=1
ASM_DATA_SIZE=$((${var.asm_reco_dg_size}*1024))
echo "RECO Diskgroup Size Disk" $ASM_DATA_SIZE
for i in $FREEDISKS; do
        size=`getconf DISK_SIZE /dev/$i`
        if [[ ( $size -eq $ASM_DATA_SIZE ) && ( $cpt -le ${var.asm_reco_dg_disk} ) ]]; then
        echo "replace $i by ASMRECO$cpt"
        rendev -l $i -n ASMRECO$cpt
        chown grid:oinstall /dev/ASMRECO$cpt /dev/rASMRECO$cpt
        chmod 660 /dev/ASMRECO$cpt /dev/rASMRECO$cpt
        lkdev -l ASMRECO$cpt -a -c ASM
        ((cpt=cpt+1))
    fi
done

LIST=""
#Configure ASM Disks for REPO Diskgroup
FREEDISKS=` lspv | grep hdisk | awk ' $2 == "none" { print $1 }'`
cpt=1
a=$((10*1024))
ASM_DATA_SIZE=$a
echo $ASM_DATA_SIZE
for i in $FREEDISKS; do
    size=`getconf DISK_SIZE /dev/$i`
    if [[ ( $size -eq $ASM_DATA_SIZE ) && ( $cpt -le 2 ) ]]; then
        echo "replace $i by ASMREPO$cpt"
        rendev -l $i -n ASMREPO$cpt
        chown grid:oinstall /dev/ASMREPO$cpt /dev/rASMREPO$cpt
        chmod 660 /dev/ASMREPO$cpt /dev/rASMREPO$cpt
        lkdev -l ASMREPO$cpt -a -c ASM
        if [ "$LIST" == "" ];then
            LIST="/dev/rASMREPO$cpt"
        else
            LIST="$LIST,/dev/rASMREPO$cpt"
        fi
        ((cpt=cpt+1))
    fi
done

export LIST

version=${var.asm_version}
asm_home=${var.asm_home}
oraclebase="/u01/oracle/grid"
oracle_inventory="/u01/oracle/inventory"
asm_password=${var.asm_password}
compatibility=`echo $version | cut -c1-2`

if [ "$asm_home" = "/u01/oracle/db_version/grid" ]; then
    asm_home=`echo $asm_home | sed -e "s/db_version/$version/g"`
fi;

chown grid:oinstall /u01

#Create ASM HOME, Oracle Base and Oracle Inventory if they do not exist
if [ ! -d "$asm_home" ]; then
 mkdir -p $asm_home
 mkdir -p $oraclebase
 mkdir -p $oracle_inventory
 chown -R grid:oinstall $asm_home
 chown -R grid:oinstall $oraclebase
 chown -R grid:oinstall $oracle_inventory
fi

#
if [ "${var.asm_home}" = "NFS Server" ]; then
	#Mount Oracle Binaries FileSystems
	nfso -o nfs_use_reserved_ports=1
	mount 10.7.33.2:/export/Oracle/ /stage
	su - grid <<EOR
	cd $asm_home
	unzip -oq /stage/grid/$version/*.zip
EOR
else
	echo "Downloading Oracle Software from IBM Cloud Object Storage"
	aws --endpoint-url="https://s3.eu-de.cloud-object-storage.appdomain.cloud" s3 sync s3://bucket-orademo/grid/$version/*.zip  $asm_home
	su - grid <<EOR
	cd $asm_home
	unzip -oq *.zip
EOR
fi

#Installation Grid Infrastructure Binaries
chmod 644 /etc/vfs

su - grid <<EOT
echo "export ORACLE_HOME=$asm_home" >> .profile
echo "export ORACLE_SID=+ASM" >> .profile
. .profile

echo "ASM REPO Diskgroup Disk List :  $LIST"

./gridSetup.sh -ignorePrereq  -force -waitforcompletion -silent                         \
    -responseFile $asm_home/install/response/gridsetup.rsp               \
INVENTORY_LOCATION=$oracle_inventory                                   \
oracle.install.option=HA_CONFIG                                                \
ORACLE_BASE=$oraclebase                                                        \
oracle.install.asm.OSDBA=oinstall                                      \
oracle.install.asm.OSASM=asmadmin                                      \
oracle.install.asm.storageOption=ASM                                   \
oracle.install.asm.SYSASMPassword=$asm_password                                \
oracle.install.asm.diskGroup.name=REPO                                 \
oracle.install.asm.diskGroup.redundancy=EXTERNAL                       \
oracle.install.asm.diskGroup.disks="$LIST"                      \
oracle.install.asm.diskGroup.diskDiscoveryString=/dev/rASM*            \
oracle.install.asm.monitorPassword=$asm_password                       \
oracle.install.crs.rootconfig.executeRootScript=true                   \
oracle.install.crs.rootconfig.configMethod=ROOT                                \
oracle.install.asm.configureAFD=false  <<EOG
y
${var.image_id_password}
EOG

$asm_home/bin/sqlplus '/as sysasm' << !!!
create diskgroup RECO external redundancy disk '/dev/rASMRECO*';
ALTER DISKGROUP RECO SET ATTRIBUTE 'compatible.asm' = '$compatibility.0';
ALTER DISKGROUP RECO SET ATTRIBUTE 'compatible.rdbms' = '$compatibility.0';
ALTER DISKGROUP RECO SET ATTRIBUTE 'compatible.advm' = '$compatibility.0';

create diskgroup DATA external redundancy disk '/dev/rASMDATA*';
ALTER DISKGROUP DATA SET ATTRIBUTE 'compatible.asm' = '$compatibility.0';
ALTER DISKGROUP DATA SET ATTRIBUTE 'compatible.rdbms' = '$compatibility.0';
ALTER DISKGROUP DATA SET ATTRIBUTE 'compatible.advm' = '$compatibility.0';

quit
!!!
EOT

if [ "${var.asm_home}" = "NFS Server" ]; then
umount /stage
fi

EOF

}

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "bash -c 'chmod +x /tmp/PrepareASMDisk.sh'",
      "bash -c '/tmp/PrepareASMDisk.sh >> PrepareASMDisk.log 2>&1'"
    ]
  }
}
  
  


output "os-user-name" {
  value = "${var.image_id_username}"
}

output "os-user-password" {
  value = "${var.image_id_password}"
}
