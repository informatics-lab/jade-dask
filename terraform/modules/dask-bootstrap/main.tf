data "template_file" "dask-bootstrap" {
  template = "${file("${path.module}/files/bootstrap.tpl")}"

  vars = {
    command = "${var.command}"
  }
}
