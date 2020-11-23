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

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/grafana.yaml

sleep 1

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/jaeger.yaml

sleep 1

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/kiali.yaml

sleep 5

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/kiali.yaml

sleep 1

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/prometheus.yaml

sleep 15

kubectl create -n istio-system secret tls all-localhost-credential --key=all.localhost.key --cert=all.localhost.crt

sleep 5

kubectl apply -f prometheus-dashboard.yaml

sleep 1  # Waits 1 seconds.

kubectl apply -f jaeger-dashboard.yaml

sleep 1  # Waits 1 seconds.

kubectl apply -f grafana-dashboard.yaml

sleep 1 # Waits 1 seconds.

kubectl apply -f kiali-dashboard.yaml

sleep 1 # Waits 1 seconds.

echo "---"
echo "token for kube dashboard login :"
echo ""
kubectl describe secret admin-user-token | grep ^token
echo "---"
echo "kiali.localhost/"
echo "kube.localhost/"
echo "jaeger.localhost/"
echo "grafana.localhost/"
echo "prometheus.localhost/"