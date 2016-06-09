variable "ssh-user" {}

resource "null_resource" "ansible-provision" {

  depends_on = ["openstack_compute_instance_v2.k8s-master","openstack_compute_instance_v2.k8s-node"]

  ##Create Master Inventory
  provisioner "local-exec" {
    command =  "echo \"[kube-master]\" > ../../../inventory"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n",formatlist("%s ansible_ssh_user=%s", openstack_compute_instance_v2.master.*.access_ip_v4, var.ssh-user))}\" >> ../../../inventory"
  }

  ##Create ETCD Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[etcd]\" >> ../../../inventory"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n",formatlist("%s ansible_ssh_user=%s", openstack_compute_instance_v2.etcd.*.access_ip_v4, var.ssh-user))}\" >> ../../../inventory"
  }

  ##Create Nodes Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[kube-node]\" >> ../../../inventory"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n",formatlist("%s ansible_ssh_user=%s", openstack_compute_instance_v2.node.*.access_ip_v4, var.ssh-user))}\" >> ../../../inventory"
  }

  provisioner "local-exec" {
    command =  "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\netcd\" >> ../../../inventory"
  }
}
