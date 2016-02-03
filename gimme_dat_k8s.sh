#!/bin/bash

##Checkout git repo if necessary, otherwise pull it
echo "Checking out latest contrib repo"
git -C contrib pull || git clone git@github.com:kubernetes/contrib.git contrib

##Create infrastructure and inventory file
echo "Creating infrastructure"
terraform apply

##Run Ansible playbooks
echo "Quick sleep while instances spin up"
sleep 120
echo "Ansible provisioning"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory -u centos contrib/ansible/cluster.yml
