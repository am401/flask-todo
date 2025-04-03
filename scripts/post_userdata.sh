#!/bin/bash

python3 -m venv venv
. venv/bin/activate

pip install -r requirements.txt

# There are some issues with version conflicts in the requirements and I found Flask fails to run without
# upgrading the above. However doing this in the requirements meant more conflicts were identified

pip install flask_wtf --upgrade
pip install flask_login --upgrade

chown -R ec2-user:nginx /var/www

# Note: assuming port 8080 is open, you can test that the app will 
# run under uwsgi manually using the following
# uwsgi --socket 0.0.0.0:8080 --protocol=http -w wsgi:app

mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf-orig
cp config/nginx.conf /etc/nginx/nginx.conf

cp config/flasktodo.conf /etc/nginx/conf.d/flasktodo.conf

cp config/flasktodo.service /etc/systemd/system/flasktodo.service

mkdir /var/log/uwsgi
chown -R ec2-user:nginx /var/log/uwsgi

systemctl start flasktodo.service
systemctl enable flasktodo.service

systemctl restart nginx
systemctl enable nginx

export FLASK_APP=wsgi
flask db upgrade

echo 'Install complete'
