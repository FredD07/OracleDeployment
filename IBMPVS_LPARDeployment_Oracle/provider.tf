provider "ibm" {
    version          = ">= 0.18.0"
    ibmcloud_api_key = "${var.ibmcloud_api_key}"
   # region           = "${var.ibmcloud_region}"
    region           = "${var.ibmcloud_zone}"
#    zone             = "${var.ibmcloud_zone}"
}
