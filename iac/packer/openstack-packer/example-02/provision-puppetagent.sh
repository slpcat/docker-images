#!/bin/bash 
# provision-puppetagent.sh   
cd /tmp; wget https://apt.puppetlabs.com/puppet5-release-xenial.deb 
sudo dpkg -i puppet5-release-xenial.deb 
sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo apt-get install -y ruby rubygems-integration puppet-agent

