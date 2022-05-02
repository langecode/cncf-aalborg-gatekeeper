#!/usr/bin/env bash

kind create cluster  --name cncf-aalborg --kubeconfig kubeconfig.yaml

helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm repo update
helm --kubeconfig kubeconfig.yaml install -n gatekeeper-system gatekeeper gatekeeper/gatekeeper --create-namespace --wait

kubectl --kubeconfig kubeconfig.yaml apply -k github.com/open-policy-agent/gatekeeper-library/library

kubectl --kubeconfig kubeconfig.yaml create ns secure
kubectl --kubeconfig kubeconfig.yaml label ns secure netic.dk/enforce-policies="true"

kubectl --kubeconfig kubeconfig.yaml create ns nonsecure

sleep 30
kubectl --kubeconfig kubeconfig.yaml apply -f pss-restricted.yaml
