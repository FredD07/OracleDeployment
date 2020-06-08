output "vm_instance_id" {
    value = "${ibm_pi_instance.pvminstance.instance_id}"
}

output "status"{
    value = "${ibm_pi_instance.pvminstance.status}"
}

output "asm_data_volumes" {
    value = "${ibm_pi_volume.asm_data_volume.*.pi_volume_name}"
}

output "asm_reco_volumes" {
    value = "${ibm_pi_volume.asm_reco_volume.*.pi_volume_name}"
}

output "ip_address" {
    #value = "${ibm_pi_instance.pvminstance.addresses}"
   value = "${lookup(ibm_pi_instance.pvminstance.addresses[0], "external_ip")}"
}

output "int_ip_address" {
   value = "${ibm_pi_instance.pvminstance.addresses[0].ip}"
}
