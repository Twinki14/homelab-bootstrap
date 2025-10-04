#!/bin/sh
apt update
apt install htop -y
apt install qemu-guest-agent -y
apt install nano -y
apt install git -y
apt install iftop -y # network bandwidth
apt install iotop -y # disk i/o
apt install net-tools -y
apt install speedtest-cli -y
DEBIAN_FRONTEND=noninteractive apt install iperf3 -y

# Configure tls hostname cert
read -p "Enter TLS SAN (IP or hostname, eg k3s.den): " TLS_SAN

# Init /etc/rancher/k3s/config.yaml from source
wget https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/k3s/config.yaml --force-directories -O /etc/rancher/k3s/config.yaml
sed -i "s|<hostname>|$TLS_SAN|g" /etc/rancher/k3s/config.yaml

# Install k3s
curl -sfL https://get.k3s.io | sh

# Install flux cli
curl -sfL https://fluxcd.io/install.sh | bash

# Reboot
reboot