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
    
 ejercicio 3:
 #!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
export AWS_PAGER=""

# Creamos el grupo de seguridad: frontend-sg
aws ec2 create-security-group \
    --group-name frontend-sg \
    --description "Reglas para el frontend"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name frontend-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTP
aws ec2 authorize-security-group-ingress \
    --group-name frontend-sg \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso HTTPS
aws ec2 authorize-security-group-ingress \
    --group-name frontend-sg \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------

# Creamos el grupo de seguridad: backend-sg
aws ec2 create-security-group \
    --group-name backend-sg \
    --description "Reglas para el backend"

# Creamos una regla de accesso SSH
aws ec2 authorize-security-group-ingress \
    --group-name backend-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Creamos una regla de accesso para MySQL
aws ec2 authorize-security-group-ingress \
    --group-name backend-sg \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0

#-----------------------------------------------------

# Variables de configuración
AMI_ID=ami-06878d265978313ca
COUNT=1
INSTANCE_TYPE=t2.small
KEY_NAME=vockey

SECURITY_GROUP_FRONTEND=frontend-sg
SECURITY_GROUP_BACKEND=backend-sg

INSTANCE_NAME_FRONTEND=frontend
INSTANCE_NAME_BACKEND=backend


# Creamos una intancia EC2 para el frontend
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_FRONTEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_FRONTEND}]"


# Creamos una intancia EC2 para el backend
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_BACKEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_BACKEND}]"
    
    # Deshabilitamos la paginación de la salida de los comandos de AWS CLI
export AWS_PAGER=""

# Guardamos una lista con todos los identificadores de las instancias EC2
SG_ID_LIST=$(aws ec2 describe-security-groups \
            --query "SecurityGroups[].GroupId" \
            --output text)

# Recorremos la lista de ids y eliminamos las instancias
for ID in $SG_ID_LIST
do
    echo "Eliminando $ID ..."
    aws ec2 delete-security-group --group-id $ID
done


# Eliminamos todas las intancias
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --query "Reservations[].Instances[*].InstanceId" --output text)
    
ejercicio 5:
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
