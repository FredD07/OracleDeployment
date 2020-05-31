resource "ibm_pi_volume" "asm_data_volume"{
  count = "${var.asm_data_dg_disk}"
  pi_volume_size       = "${var.asm_data_dg_size}"
  pi_volume_name       = "${var.vm_name}_${format("asm_data-%02d", count.index + 1)}"
  pi_volume_type       = "${var.asm_data_type}"
  pi_volume_shareable  = false
  pi_cloud_instance_id = "${var.power_instance_id}"
}

data "ibm_pi_volume" "ds_asm_data_volume" {
  depends_on           = ["ibm_pi_volume.asm_data_volume"]
count = "${var.asm_data_dg_disk}"
  pi_cloud_instance_id = "${var.power_instance_id}" 
  pi_volume_name      = "${var.vm_name}_${format("asm_data-%02d", count.index + 1)}" 
}

resource "ibm_pi_volume" "asm_reco_volume"{
  count = "${var.asm_reco_dg_disk}"
  pi_volume_size       = "${var.asm_reco_dg_size}"
  pi_volume_name       = "${var.vm_name}_${format("asm_reco-%02d", count.index + 1)}"
  pi_volume_type       = "${var.asm_reco_type}"
  pi_volume_shareable  = false
  pi_cloud_instance_id = "${var.power_instance_id}"
}

data "ibm_pi_volume" "ds_asm_reco_volume" {
  depends_on           = ["ibm_pi_volume.asm_reco_volume"]
count = "${var.asm_reco_dg_disk}"
  pi_cloud_instance_id = "${var.power_instance_id}"
  pi_volume_name      = "${var.vm_name}_${format("asm_reco-%02d", count.index + 1)}"
}

resource "ibm_pi_volume" "asm_repo_volume"{
  count = "2"
  pi_volume_size       = "10"
  pi_volume_name       = "${var.vm_name}_${format("asm_repo-%02d", count.index + 1)}"
  pi_volume_type       = "tier3"
  pi_volume_shareable  = false
  pi_cloud_instance_id = "${var.power_instance_id}"
}

data "ibm_pi_volume" "ds_asm_repo_volume" {
  depends_on           = ["ibm_pi_volume.asm_repo_volume"]
  count = "2"
  pi_cloud_instance_id = "${var.power_instance_id}"
  pi_volume_name      = "${var.vm_name}_${format("asm_repo-%02d", count.index + 1)}"
}

#create private network list
#data "ibm_pi_network" "power_networks" {
#    count                = "${length(var.networks)}"
#    pi_network_name      = "${var.networks[count.index]}"
#    pi_cloud_instance_id = "${var.power_instance_id}"
#  pi_network_type      = "pub-vlan"
#  pi_dns               = ["9.9.9.9"]
#}

#create public network
resource "ibm_pi_network" "power_networks" {
    count                = "1"
    pi_network_name      = "pub_network${var.vm_name}"
    pi_cloud_instance_id = "${var.power_instance_id}"
  pi_network_type      = "pub-vlan"
  pi_dns               = ["9.9.9.9"]
}

data "ibm_pi_network" "ds_power_networks" {
  depends_on           = ["ibm_pi_network.power_networks"]
count = "1"
  pi_cloud_instance_id = "${var.power_instance_id}"
  pi_volume_name      = "pub_network${var.vm_name}"
} 

data "ibm_pi_image" "power_images" {
    pi_image_name        = "${var.image_name}"
    pi_cloud_instance_id = "${var.power_instance_id}"
}

resource "ibm_pi_instance" "pvminstance" {
    pi_memory             = "${var.memory}"
    pi_processors         = "${var.processors}"
    pi_instance_name      = "${var.vm_name}"
    pi_proc_type          = "${var.proc_type}"
#    pi_migratable         = "${var.migratable}"
    pi_image_id           = "${data.ibm_pi_image.power_images.id}"
    pi_network_ids        = ["${data.ibm_pi_network.ds_power_networks.networkid}"]
    pi_pin_policy         = "hard"
    pi_key_pair_name      = ""
#  pi_key_pair_name      = "${var.ssh_key_name}"
    pi_sys_type           = "${var.system_type}"
    pi_replication_policy = "${var.replication_policy}"
    pi_replication_scheme = "${var.replication_scheme}"
    pi_replicants         = "${var.replicants}"
    pi_cloud_instance_id  = "${var.power_instance_id}"
    pi_volume_ids         = ["${ibm_pi_volume.asm_data_volume.*.volume_id}","${ibm_pi_volume.asm_reco_volume.*.volume_id}","${ibm_pi_volume.asm_repo_volume.*.volume_id}"]

    # Specify the ssh connection
  connection {
     type        = "ssh"
     host        = "${lookup(ibm_pi_instance.pvminstance.addresses[0], "external_ip")}"
            timeout     = "60m"
            user        = "root"
    password = "oracle1bm"
    #password = "${var.image_id_password}"
   # timeout  = "60m"
  }
  
}

