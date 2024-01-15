#!/bin/bash

apt update;
apt upgrade -y;
apt install docker.io docker-compose nginx -y;
rm -rf /etc/nginx/sites-enabled/default;

cp env.example .env;

input_port=$(cat .env | grep "PORT");
port_value="${input_port#*=}";
server_name=$1;
nginx_file="${server_name}.conf";

cp wordpress.conf "./${server_name}.conf";
sed -i "s/serverName/${server_name}/g" "$nginx_file";
sed -i "s/serverPort/${port_value}/g" "$nginx_file";

docker-compose up -d;

mv "./${server_name}.conf" /etc/nginx/sites-enabled/;
systemctl reload nginx;
