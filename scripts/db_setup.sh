#!/bin/bash

source /var/www/.env

. venv/bin/activate

yum install postgresql15.x86_64 postgresql15-server -y

su postgres -c "pg_ctl init -D /var/lib/pgsql/data"

systemctl start postgresql
systemctl enable postgresql

su postgres -c "psql -c \"CREATE USER flasktodo WITH PASSWORD '$(printf '%s' "$PSQL_PASSWORD")'\""
su postgres -c 'createdb -e --owner=flasktodo todos'

export FLASK_APP=wsgi

systemctl restart flasktodo
systemctl restart nginx

flask db upgrade
