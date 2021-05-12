#!/bin/bash
kubectl apply -f mongodb-secret.yml
kubectl apply -f mongodb-pv.yml
kubectl apply -f mongodb-pvc.yml
kubectl apply -f mongodb-deployment.yml