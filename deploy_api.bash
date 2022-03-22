#!/bin/bash

keys=$1
dbAddress=$2
ec2PrivateIP=$4
ec2PublicDNS=$3

scp -i $1 ~/net_config.json "ubuntu@$ec2PublicDNS:~/net_config.json"
ssh -i $1 "ubuntu@$ec2PublicDNS" << EOF
  wget https://dl.google.com/go/go1.17.7.linux-amd64.tar.gz
  sudo tar -xvf go1.17.7.linux-amd64.tar.gz
  sudo mv go /usr/local
  export GOROOT=/usr/local/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
  go env

  git clone https://github.com/kaarla/clip-exercise.git
  cd clip-exercise
  mysql -h $dbAddress -u root --password=my-secret-pw < database/pets_schema.sql
  cd api/cmd/petsapi
  go build
  ./petsapi $ec2PrivateIP $dbAddress &
EOF
