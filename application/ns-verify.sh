#!/bin/bash

# List of namespaces
NAMESPACES=("nginx" "argocd")

for NAMESPACE in "${NAMESPACES[@]}"; do
  if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo "Creating namespace '$NAMESPACE'"
    kubectl create namespace "$NAMESPACE"
  else
    echo "Namespace '$NAMESPACE' already exists. Skipping creation."
  fi
done
