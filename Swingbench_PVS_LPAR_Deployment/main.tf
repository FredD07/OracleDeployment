


data "ibm_pi_network" "power_networks" {
    count                = "1"
    pi_network_name      = "${var.networks}"
    pi_cloud_instance_id = "${var.power_instance_id}"
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
    pi_network_ids        = ["${data.ibm_pi_network.power_networks.id}"]
    pi_pin_policy         = "hard"
    pi_key_pair_name      = ""
#  pi_key_pair_name      = "${var.ssh_key_name}"
    pi_sys_type           = "${var.system_type}"
    pi_replication_policy = "${var.replication_policy}"
    pi_replication_scheme = "${var.replication_scheme}"
    pi_replicants         = "${var.replicants}"
    pi_cloud_instance_id  = "${var.power_instance_id}"
    pi_volume_ids         = [""]

    # Specify the ssh connection
  connection {
     type        = "ssh"
     host        = "${lookup(ibm_pi_instance.pvminstance.addresses[0], "external_ip")}"
     timeout     = "60m"
     user        = "${var.image_id_username}"
     password = "${var.image_id_password}"

  }
  
}

