/* Specify all templates to be used here */

data "template_file" "oc-worker" {
   template = "${file("${path.module}/templates/userdata-worker")}"
}
