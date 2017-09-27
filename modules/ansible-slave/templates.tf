/* Specify all templates to be used here */

data "template_file" "userdata-ansible-slave" {
   template = "${file("${path.module}/templates/userdata-ansible-slave")}"
}
