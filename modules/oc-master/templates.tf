/* Specify all templates to be used here */

data "template_file" "oc-master" {
   template = "${file("${path.module}/templates/userdata-master")}"
}
