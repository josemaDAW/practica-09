#!/bin/bash

aws ec2 create-security-group \
    --group-name backend-sg-1 \
    --description "Grupo de seguridad backend"

aws ec2 authorize-security-group-ingress \
    --group-name backend-sg-1 \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

    aws ec2 authorize-security-group-ingress \
    --group-name backend-sg-1 \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0