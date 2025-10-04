#!/bin/bash

# Tools
apt update
apt install -y sudo curl htop qemu-guest-agent nano git iftop iotop net-tools speedtest-cli iperf3

# Prompt to add user to sudoers
read -p "Add sudoer: " username
if [ -n "$username" ]; then
    sudo adduser "$username" sudo
fi

# Prompt current hosts/hostname
echo "-> Current /etc/hostname & /etc/hosts"
echo
echo "/etc/hostname:"
cat /etc/hostname
echo
echo "/etc/hosts:"
cat /etc/hosts
echo
echo "-> Adjust /etc/hostname and update /etc/hosts accordingly if desired"
echo

# Configure k3s tls hostname cert
read -p "k3s TLS SAN (IP or hostname, eg k3s.den): " TLS_SAN

# Init /etc/rancher/k3s/config.yaml from source
mkdir -p /etc/rancher/k3s
wget https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/k3s/config.yaml --force-directories -O /etc/rancher/k3s/config.yaml
sed -i "s|<hostname>|$TLS_SAN|g" /etc/rancher/k3s/config.yaml

# Install k3s
curl -sfL https://get.k3s.io | sh

# Install flux cli
curl -sfL https://fluxcd.io/install.sh | bash

# Reboot
sudo reboot