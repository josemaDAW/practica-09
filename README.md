# practica-09-Ansible
El objetivo de este tutorial es entender algunos de los conceptos básicos de Ansible y ponerlos en práctica realizando tareas sencillas de administración sobre instancias EC2 de AWS.
2. ¿Qué es Ansible?
Ansible es una herramienta que nos permite configurar, administrar y realizar instalaciones en sistemas cloud con múltiples nodos sin tener que instalar agentes software en ellos. Sólo es necesario instalar Ansible en la máquina principal desde la que vamos a realizar operaciones sobre el resto de nodos y ésta se conectará a los nodos a través de SSH.
Primero en AWS preparamos dos instancia con ubuntu, una vez creadas instalamos ansible con estos dos comandos ($ sudo apt update
$ sudo apt install ansible) 
Configuración del archivo de inventario de Ansible
De momento la única configuración que vamos a realizar en Ansible será editar el archivo de inventario /etc/ansible/hosts para incluir la lista de hosts sobre los que vamos a realizar tareas con Ansible.
--
Ejercicio 1
--
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
   

   Ejercicio 2

   # Variables de configuración
    AMI_ID=ami-08e637cea2f053dfa
    COUNT=1
    INSTANCE_TYPE=t2.micro
    KEY_NAME=vockey
    SECURITY_GROUP_BACKEND=backend-sg
   # Creamos una intancia EC2 para el backend
aws ec2 run-instances \
    --name backend \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_BACKEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_BACKEND}]"

   Ejercicio 3

  
  #!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""

# Obtenemos una lista con los identificadores de las instancias que están en ejecución
EC2_ID_LIST=$(aws ec2 describe-instances \
                --filters "Name=instance-state-name,Values=running" \
                --query "Reservations[*].Instances[*].InstanceId" \
                --output text)

# Eliminamos todas las intancias que están en ejecución
aws ec2 terminate-instances \
    --instance-ids $EC2_ID_LIST
    
    
    

    ejercicio 4
 
    
    
    
    
    
    
    
ejercicio 5

!/bin/bash
# Get the list of all running EC2 instances
instances=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].[InstanceId,PublicIpAddress]" --output text)

# Iterate through the list and display the instance name and public IP
for instance in $instances; do
    instance_id=$(echo $instance | awk '{print $1}')
    public_ip=$(echo $instance | awk '{print $2}')
    echo "Instance ID: $instance_id, Public IP: $public_ip"
done
