/* Specify all templates to be used here */


data "template_file" "userdata-bastion" {
   template = "${file("${path.module}/templates/userdata_bastion")}"
}
