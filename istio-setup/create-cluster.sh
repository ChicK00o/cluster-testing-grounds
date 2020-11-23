#!/usr/bin/env bash

k3d cluster create devcluster --api-port 0.0.0.0:6443 -p 80:80@loadbalancer -p 443:443@loadbalancer --k3s-server-arg --disable=traefik

sleep 10  # Waits 1 seconds.

k3d kubeconfig get devcluster > $HOME/.kube/config

sleep 1  # Waits 1 seconds.

istioctl install --set profile=demo

sleep 1  # Waits 1 seconds.

kubectl label namespace default istio-injection=enabled

sleep 1  # Waits 1 seconds.

kubectl apply -f kube-dashboard.yaml

sleep 15  # Waits 1 seconds.

kubectl describe secret admin-user-token | grep ^token

echo "---"
echo "kube.localhost/"