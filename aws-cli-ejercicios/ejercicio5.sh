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
