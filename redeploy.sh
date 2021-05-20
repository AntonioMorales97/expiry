#!/bin/bash
## Git pull for refresh
git pull;
wait;
## bulid dumbledore
cd dumbledore;
sudo mvn package -Dspring.profiles.active=prod -Dmaven.test.skip=true;
wait;
sudo docker build --tag=dumbledore:latest .;
wait;
## build filtch
cd ..;
cd filtch;
sudo mvn package -Dspring.profiles.active=prod -Dmaven.test.skip=true;
wait
sudo docker build --tag=filtch:latest .;
wait;
cd ..;
cd ..;
##remove images for both dumbledore and filtch
cd images;
sudo rm filtch.tar;
sudo rm dumbledore.tar;
## save tar files of dumbledore and filtch
sudo docker save --output dumbledore.tar dumbledore:latest;
wait;
sudo docker save --output filtch.tar filtch:latest;
wait;
##rmove images from k3s.
sudo k3s ctr images remove dumbledore.tar;
sudo k3s ctr images remove filtch.tar;
##import images to k3s.
sudo k3s ctr images import dumbledore.tar;
wait;
sudo k3s ctr images import filtch.tar;
wait;
## remove filtch + dumbledore services and deploys from k3s.
sudo kubectl remove deployments,services filtch filtch;
sudo kubectl remove deployments, services dumbledore, dumbledore;
cd ../deploy/dumbledore;
sudo ./deploy.sh;
cd ../filtch;
sudo ./deploy.sh;
