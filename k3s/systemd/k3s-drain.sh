#!/bin/bash
set -e

NODE_NAME=$(hostname)

# Ensure kubeconfig exists
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Skip if API is gone
if ! kubectl get node "$NODE_NAME" >/dev/null 2>&1; then
  echo "Node $NODE_NAME not found in cluster, skipping drain"
  exit 0
fi

kubectl cordon "$NODE_NAME"

echo "Draining node..."

kubectl drain "$NODE_NAME" \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --force \
  --grace-period=60 \
  --timeout=240s

echo "Drain finished"