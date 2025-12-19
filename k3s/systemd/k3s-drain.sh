#!/bin/bash
set -e

NODE_NAME=$(hostname)

# Ensure kubeconfig exists
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Skip if API is already gone
kubectl get node "$NODE_NAME" >/dev/null 2>&1 || exit 0

kubectl cordon "$NODE_NAME"

kubectl drain "$NODE_NAME" \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --force \
  --grace-period=60 \
  --timeout=240s