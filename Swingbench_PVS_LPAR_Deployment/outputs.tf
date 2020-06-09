output "vm_instance_id" {
    value = "${ibm_pi_instance.pvminstance.instance_id}"
}

output "status"{
    value = "${ibm_pi_instance.pvminstance.status}"
}

output "ip_address" {
    #value = "${ibm_pi_instance.pvminstance.addresses}"
   value = "${lookup(ibm_pi_instance.pvminstance.addresses[0], "external_ip")}"
}

output "int_ip_address" {
   value = "${ibm_pi_instance.pvminstance.addresses.0.ip}"
}
