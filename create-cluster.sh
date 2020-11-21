#!/usr/bin/env bash

k3d cluster create devcluster --api-port 0.0.0.0:6443 -p 80:80@loadbalancer -p 443:443@loadbalancer --k3s-server-arg --disable=traefik

k3d kubeconfig get devcluster > $HOME/.kube/config

helm install traefik traefik/traefik -f traefik-helm-override.yaml

kubectl apply -f traefik-dashboard.yaml

kubectl apply -f kube-dashboard.yaml

kubectl apply -f kube-dash-ingress.yaml

kubectl apply -f jaeger-dashboard.yaml

kubectl apply -f grafana-dashboard.yaml

echo "---"
echo "token for kube dashboard login :"
echo ""
kubectl describe secret admin-user-token | grep ^token
echo "---"
echo "traefik.localhost/dashboard"
echo "kube.localhost"
echo "jaeger.localhost"
echo "grafana.localhost"