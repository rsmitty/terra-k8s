resource "null_resource" "ansible-provision" {

  depends_on = ["openstack_compute_instance_v2.k8s-master","openstack_compute_instance_v2.k8s-node"]

  ##Create Masters Inventory
  provisioner "local-exec" {
    command =  "echo \"[masters]\n${openstack_compute_floatingip_v2.master-ip.address}\" > inventory"
  }

  ##Create ETCD Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[etcd]\n${openstack_compute_floatingip_v2.master-ip.address}\" >> inventory"
  }

  ##Create Nodes Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[nodes]\" >> inventory"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n",openstack_compute_floatingip_v2.node-ip.*.address)}\" >> inventory"
  }

}
