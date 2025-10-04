#!/bin/bash

# Tools
apt update
DEBIAN_FRONTEND=noninteractive apt install -y \
  curl \
  htop \
  qemu-guest-agent \
  nano \
  git \
  iftop \
  iotop \
  net-tools \
  speedtest-cli \
  iperf3

# Configure tls hostname cert
read -p "Enter TLS SAN (IP or hostname, eg k3s.den): " TLS_SAN

# Init /etc/rancher/k3s/config.yaml from source
mkdir -p /etc/rancher/k3s
wget https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/k3s/config.yaml --force-directories -O /etc/rancher/k3s/config.yaml
sed -i "s|<hostname>|$TLS_SAN|g" /etc/rancher/k3s/config.yaml

# Install k3s
curl -sfL https://get.k3s.io | sh

# Install flux cli
curl -sfL https://fluxcd.io/install.sh | bash

# Reboot
reboot