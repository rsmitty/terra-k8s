##Ask for desired amount of k8s nodes
variable "node-count" {
  default = "2"
}

##Create a single master node and floating IP
resource "openstack_compute_floatingip_v2" "master-ip" {
  pool = "external_network"
}

resource "openstack_compute_instance_v2" "k8s-master" {
  name = "k8s-master"
  image_name = "centos7-feb16"
  flavor_name = "m1.tiny"
  key_pair = "spencer-key"
  security_groups = ["default","k8s-cluster"]
  network {
    name = "private_network"
  }
  floating_ip = "${openstack_compute_floatingip_v2.master-ip.address}"
}

##Create desired number of k8s nodes and floating IPs
resource "openstack_compute_floatingip_v2" "node-ip" {
  pool = "external_network"
  count = "${var.node-count}"
}

resource "openstack_compute_instance_v2" "k8s-node" {
  count = "${var.node-count}"
  name = "k8s-node-${count.index}"
  image_name = "centos7-feb16"
  flavor_name = "m1.tiny"
  key_pair = "spencer-key"
  security_groups = ["default","k8s-cluster"]
  network {
    name = "private_network"
  }
  floating_ip = "${element(openstack_compute_floatingip_v2.node-ip.*.address, count.index)}"
}
