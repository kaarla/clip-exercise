#!/bin/bash

# terraform apply -auto-approve
# terraform output -json > ~/net_config.json

keys=$1
ec2PublicDNS=$(jq ".\"ec2-public-dns\".value" ~/net_config.json)

scp -i $1 ~/net_config.json "ubuntu@$2:~/net_config.json"
ssh -i $1 "ubuntu@$2"
