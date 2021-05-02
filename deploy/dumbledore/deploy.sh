#!/bin/bash
kubectl apply -f dumbledore-secret.yml
kubectl apply -f dumbledore-configmap.yml
kubectl apply -f dumbledore-deployment.yml