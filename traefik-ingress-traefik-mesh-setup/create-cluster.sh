#!/usr/bin/env bash

k3d cluster create devcluster --api-port 0.0.0.0:6443 -p 80:80@loadbalancer -p 443:443@loadbalancer --k3s-server-arg --disable=traefik

sleep 10  # Waits 1 seconds.

k3d kubeconfig get devcluster > $HOME/.kube/config

sleep 1  # Waits 1 seconds.

helm install traefik traefik/traefik -f traefik-helm-override.yaml

sleep 10  # Waits 1 seconds.

helm install traefik-mesh traefik-mesh/traefik-mesh -f traefik-mesh-helm-override.yaml

sleep 10  # Waits 1 seconds.

kubectl apply -f traefik-dashboard.yaml

sleep 1  # Waits 1 seconds.

kubectl apply -f kube-dashboard.yaml

sleep 15  # Waits 1 seconds.

kubectl apply -f kube-dash-ingress.yaml

sleep 1  # Waits 1 seconds.

kubectl apply -f jaeger-dashboard.yaml

sleep 1  # Waits 1 seconds.

kubectl apply -f grafana-dashboard.yaml

sleep 1  # Waits 1 seconds.

kubectl apply -f prometheus-dashboard.yaml

sleep 1  # Waits 1 seconds.

echo "---"
echo "token for kube dashboard login :"
echo ""
kubectl describe secret admin-user-token | grep ^token
echo "---"
echo "traefik.localhost/dashboard/"
echo "kube.localhost/"
echo "jaeger.localhost/"
echo "grafana.localhost/"
echo "prometheus.localhost/"