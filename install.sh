#!/bin/bash

# Install dependencies
apt update;
apt upgrade -y;
apt install docker.io docker-compose nginx -y;
rm -rf /etc/nginx/sites-enabled/default;

# Add more ram for server by using swap
fallocate -l 1G /swapfile;
chmod 600 /swapfile;
mkswap /swapfile;
swapon /swapfile;

# Config nginx file base on env setup
cp env.example .env;
input_port=$(cat .env | grep "PORT");
port_value="${input_port#*=}";
server_name=$1;
nginx_file="${server_name}.conf";
cp wordpress.conf "./${server_name}.conf";
sed -i "s/serverName/${server_name}/g" "$nginx_file";
sed -i "s/serverPort/${port_value}/g" "$nginx_file";

# Start service using docker
docker-compose up -d;

# Move config file for nginx and reload nginx
mv "./${server_name}.conf" /etc/nginx/sites-enabled/;
systemctl reload nginx;
