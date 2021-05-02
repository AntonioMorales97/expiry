#!/bin/bash
kubectl apply -f mongo-configmap.yml
kubectl apply -f mongodb-express-deployment.yml