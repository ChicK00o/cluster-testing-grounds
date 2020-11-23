#!/usr/bin/env bash
k3d cluster start devcluster

sleep 15  # Waits 15 seconds.

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