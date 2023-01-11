# practica-09-Ansible
El objetivo de este tutorial es entender algunos de los conceptos básicos de Ansible y ponerlos en práctica realizando tareas sencillas de administración sobre instancias EC2 de AWS.
2. ¿Qué es Ansible?
Ansible es una herramienta que nos permite configurar, administrar y realizar instalaciones en sistemas cloud con múltiples nodos sin tener que instalar agentes software en ellos. Sólo es necesario instalar Ansible en la máquina principal desde la que vamos a realizar operaciones sobre el resto de nodos y ésta se conectará a los nodos a través de SSH.
Primero en AWS preparamos dos instancia con ubuntu, una vez creadas instalamos ansible con estos dos comandos ($ sudo apt update
$ sudo apt install ansible) 
Configuración del archivo de inventario de Ansible
De momento la única configuración que vamos a realizar en Ansible será editar el archivo de inventario /etc/ansible/hosts para incluir la lista de hosts sobre los que vamos a realizar tareas con Ansible.
