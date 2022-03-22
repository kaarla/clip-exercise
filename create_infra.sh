#!/bin/bash

cd infra
terraform apply -auto-approve -var="key_name=$1"
terraform output -json > ~/net_config.json

cd ..
