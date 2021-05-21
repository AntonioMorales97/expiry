#!/bin/bash

#Check if last command was successful
command_success (){
    retval=$?
    if [ $retval -ne 0 ]; then
        echo 'ERROR :('
        exit
    fi
}

## Git pull for refresh
echo 'Git pull'

git pull

command_success

## bulid dumbledore
echo 'Building dumbledore...'
sudo mvn -f ./dumbledore package -Dspring.profiles.active=prod -Dmaven.test.skip=true

command_success

sudo docker build --tag=dumbledore:latest ./dumbledore

command_success
echo 'OK'

## build filtch
echo 'Building filtch...'
sudo mvn -f ./filtch package -Dspring.profiles.active=prod -Dmaven.test.skip=true

command_success

sudo docker build --tag=filtch:latest ./filtch

command_success
echo 'OK'

## save tar files of dumbledore and filtch
echo 'Saving tar files'
sudo docker save --output dumbledore.tar dumbledore:latest
command_success
sudo docker save --output filtch.tar filtch:latest
command_success
echo 'OK'
##remove images from k3s.
echo 'Removing images from k3s'
sudo k3s ctr images remove dumbledore:latest
sudo k3s ctr images remove filtch:latest
echo 'OK'
##import images to k3s.
echo 'Importing images to k3s'
sudo k3s ctr images import dumbledore.tar
command_success
sudo k3s ctr images import filtch.tar
command_success
echo 'OK'
##remove images for both dumbledore and filtch
echo 'Cleaning tar files'
sudo rm filtch.tar
sudo rm dumbledore.tar
echo 'OK'
## remove filtch + dumbledore services and deploys from k3s.
echo 'Removing deployments and services'
sudo kubectl delete deployments,services filtch filtch
sudo kubectl delete deployments,services dumbledore dumbledore
echo 'OK'

## Deploy
echo 'Deploying...'
sudo kubectl apply -f ./deploy/filtch/filtch-secret.yml
sudo kubectl apply -f ./deploy/filtch/filtch-configmap.yml
sudo kubectl apply -f ./deploy/filtch/filtch-deployment.yml
echo 'Deploying dumbledore...'
sudo kubectl apply -f ./deploy/dumbledore/dumbledore-secret.yml
sudo kubectl apply -f./deploy/dumbledore/dumbledore-configmap.yml
sudo kubectl apply -f ./deploy/dumbledore/dumbledore-deployment.yml
echo 'OK'
echo 'FINISHED'
