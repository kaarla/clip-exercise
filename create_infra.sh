#!/bin/bash

cd infra
terraform apply -auto-approve
terraform output -json > ~/net_config.json

cd ..
