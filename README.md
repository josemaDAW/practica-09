!/bin/bash

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
ejercicio2:
#!/bin/bash

aws ec2 run-instances \
    --image-id ami-0557a15b87f6559cf \
    --count 1 \
    --instance-type t2.micro \
    --key-name vockey \
    --security-groups backend-sg-1 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=backend}]"
ejercicio5:
#!/bin/bash

# Obtener información de todas las instancias EC2 en ejecución
instances=$(aws ec2 describe-instances --filter "Name=instance-state-name,Values=running")

# Extraer nombre y dirección IP pública de cada instancia
echo "Nombre de la instancia | Dirección IP pública"
echo "---------------------------------------------"
for i in $(echo $instances | jq -r '.Reservations[].Instances[] | [.Tags[0].Value, .PublicIpAddress] | @tsv'); do
    name=$(echo $i | awk '{print $1}')
    ip=$(echo $i | awk '{print $2}')
    echo "$name | $ip"
done
