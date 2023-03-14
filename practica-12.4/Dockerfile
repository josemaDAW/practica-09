FROM nginx:1.23

#Instalamos el software necesario
RUN apt update \
&& apt install git -y

#Clonamos y movemos el codigo
RUN git clone https://github.com/josejuansanchez/2048.git  /tmp/2048\
&& cp -R /tmp/2048/* /usr/share/nginx/html/

#Inidcamos el puerto de donde estara el servicio
EXPOSE 80

#Indicamos el comando que se ejecutara cuando se cree el contenedor
ENTRYPOINT [ "nginx","-g", "'daemon off;'" ]