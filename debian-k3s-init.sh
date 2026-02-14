#!/bin/bash

# Prompt current hosts/hostname/nodename
echo "-> Current /etc/hostname & /etc/hosts"
echo
echo "/etc/hostname:"
cat /etc/hostname
echo
echo "/etc/hosts:"
cat /etc/hosts
echo
echo "-> Adjust /etc/hostname and update /etc/hosts accordingly if desired"
read -p "-> Continue? (y/n): " choice
[ "$choice" != "y" ] && exit 0

# Configure k3s tls hostname cert
read -p "k3s TLS SAN (IP or hostname, eg k3s.den): " TLS_SAN

# Init /etc/rancher/k3s/config.yaml from source
mkdir -p /etc/rancher/k3s
wget https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/k3s/config.yaml --force-directories -O /etc/rancher/k3s/config.yaml
wget https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/k3s/kubelet.yaml --force-directories -O /etc/rancher/k3s/kubelet.yaml
sed -i "s|<hostname>|$TLS_SAN|g" /etc/rancher/k3s/config.yaml

# Install k3s
curl -sfL https://get.k3s.io | sh

# Install flux cli
curl -sfL https://fluxcd.io/install.sh | bash

# Install k9s
curl -L -O https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb \
  && sudo dpkg -i k9s_linux_amd64.deb \
  && rm k9s_linux_amd64.deb

# Point KUBECONFIG to the k3s kubeconfig if KUBECONFIG isn't already set
grep -q '^KUBECONFIG=' /etc/environment || echo "KUBECONFIG=/etc/rancher/k3s/k3s.yaml" | sudo tee -a /etc/environment > /dev/null

# System-wide kubectl -> k alias
if ! grep -q "alias k='kubectl'" /etc/profile.d/kubectl-alias.sh 2>/dev/null; then
  echo "alias k='kubectl'" | sudo tee /etc/profile.d/kubectl-alias.sh > /dev/null
  sudo chmod +x /etc/profile.d/kubectl-alias.sh
fi

# Reboot
sudo reboot