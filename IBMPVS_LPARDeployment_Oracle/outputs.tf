output "adress" {
    value = "${ibm_pi_instance.pvminstance.addresses[0]}"
}

output "vm_instance_id" {
    value = "${ibm_pi_instance.pvminstance.instance_id}"
}

output "health_status" {
    value = "${ibm_pi_instance.pvminstance.health_status}"
}

output "ip_address" {
    value = "${ibm_pi_instance.pvminstance.addresses}"
}

#output "progress" {
#    value = "${ibm_pi_instance.pvminstance.progress}"
#}
