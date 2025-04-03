#!/bin/bash

yum update -y
yum install nginx -y
yum install git -y
yum install gcc gcc-c++ make -y
yum install python3-pip python3-devel python3-setuptools -y


aws configure set region us-east-1

mkdir -p /var/www

git clone https://github.com/am401/flask-todo.git /var/www

cd /var/www

git config core.fileMode false

aws s3 cp s3://tci-s3-demo-210325/flask-todo/.env .env

chmod +x scripts/post_userdata.sh

./scripts/post_userdata.sh
