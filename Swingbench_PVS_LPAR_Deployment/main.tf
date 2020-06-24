


resource "ibm_pi_network" "power_networks" {
   #  count                = "${length(var.networks)}"
   count = ${contains(var.networks), var.vm_name) ? 1 : 0 }  
   #count = "${var.networks==\"${var.vm_name}-db\" ? 1 :0 }"
    # pi_network_name      = "${var.networks[count.index]}"
     pi_network_name "${var.vm_name}"
    pi_cloud_instance_id = "${var.power_instance_id}"
     pi_network_type      = "pub-vlan"
  pi_dns               = ["9.9.9.9"]
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
    pi_volume_ids         = []

    # Specify the ssh connection
  connection {
     type        = "ssh"
     host        = "${lookup(ibm_pi_instance.pvminstance.addresses[0], "external_ip")}"
     timeout     = "60m"
     user        = "${var.image_id_username}"
     password = "${var.image_id_password}"

  }
  
     provisioner "file" {
    destination = "/tmp/ResetRMC.sh"
    content     = <<EOF
#!/bin/ksh

/usr/sbin/rsct/bin/rmcctrl -z
/usr/sbin/rsct/bin/rmcctrl -A
/usr/sbin/rsct/bin/rmcctrl -p

EOF
}

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "bash -c 'chmod +x /tmp/ResetRMC.sh'",
      "bash -c '/tmp/ResetRMC.sh >> ResetRMC.log 2>&1'"
    ]
  }
     
}

