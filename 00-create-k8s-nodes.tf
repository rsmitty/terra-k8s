##Setup needed variables
variable "master-count" {}
variable "etcd-count" {}
variable "node-count" {}
variable "internal-ip-pool" {}
variable "image-name" {}
variable "image-flavor" {}
variable "security-groups" {}
variable "key-pair" {}
variable "az" {}

resource "openstack_compute_instance_v2" "master" {
  count = "${var.master-count}"
  name = "k8s-master-${count.index}"
  image_name = "${var.image-name}"
  flavor_name = "${var.image-flavor}"
  key_pair = "${var.key-pair}"
  security_groups = ["${split(",", var.security-groups)}"]
  network {
    name = "${var.internal-ip-pool}"
  }
  availability_zone = "${var.az}"
}

resource "openstack_compute_instance_v2" "etcd" {
  count = "${var.etcd-count}"
  name = "k8s-etcd-${count.index}"
  image_name = "${var.image-name}"
  flavor_name = "${var.image-flavor}"
  key_pair = "${var.key-pair}"
  security_groups = ["${split(",", var.security-groups)}"]
  network {
    name = "${var.internal-ip-pool}"
  }
  availability_zone = "${var.az}"
}

resource "openstack_compute_instance_v2" "node" {
  count = "${var.node-count}"
  name = "k8s-node-${count.index}"
  image_name = "${var.image-name}"
  flavor_name = "${var.image-flavor}"
  key_pair = "${var.key-pair}"
  security_groups = ["${split(",", var.security-groups)}"]
  network {
    name = "${var.internal-ip-pool}"
  }
  availability_zone = "${var.az}"
}
