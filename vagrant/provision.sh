#!/bin/bash
# the default ubuntu install has very outdated ansible
add-apt-repository ppa:ansible/ansible
apt-get update
apt-get install -y ansible
su vagrant -c "ansible-galaxy collection build --force"
su vagrant -c "ansible-galaxy collection install *.tar.gz"
su vagrant -c "ansible-galaxy install -r requirements.yml"