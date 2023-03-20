#!/bin/bash
aws ec2 run-instances \
    --image-id ami-0557a15b87f6559cf \
    --count 1 \
    --instance-type t2.micro \
    --key-name vockey \
    --security-groups backend-sg-1 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=backend}]"