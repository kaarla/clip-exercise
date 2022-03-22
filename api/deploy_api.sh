#!/bin/bash

sudo apt-get install -y jq
dbAddress=$(jq ".\"db-address\".value" ~/net_config.json)
ec2PrivateIP=$(jq ".\"ec2-public-private-ip\".value" ~/net_config.json)

wget https://dl.google.com/go/go1.17.7.linux-amd64.tar.gz
sudo tar -xvf go1.17.7.linux-amd64.tar.gz
sudo mv go /usr/local
sudo export GOROOT=/usr/local/go
sudo export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
go env

git clone https://github.com/kaarla/clip-exercise.git
cd clip-exercise
mysql -h $dbAddress -u root --password=my-secret-pw < database/pets_schema.sql
cd api/cmd/petsapi
go build
./petsapi $ec2PrivateIP dbAddress
