#!/bin/bash
set -euxo pipefail
cd $(dirname "$0")

docker pull hello-world
docker tag hello-world registry:5000/hello-world
docker push registry:5000/hello-world

kind create cluster --config kind-cluster-config.yml

kubectl wait po --all --for=condition=ready --namespace kube-system
sleep 5
kubectl wait po --all --for=condition=ready --namespace kube-system
sleep 5

while :; do
	if kubectl run hello-world --image=registry:5000/hello-world; then
		break
	fi
	sleep 5
done

kubectl wait po hello-world --for=condition=complete || :
kubectl get po
kubectl logs hello-world
