#!/bin/bash
kubectl apply -f filtch-secret.yml
kubectl apply -f filtch-configmap.yml
kubectl apply -f filtch-deployment.yml