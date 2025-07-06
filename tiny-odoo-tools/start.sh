#! /bin/bash

init=0
while getopts "i" flag
do
    case "${flag}" in
        i) init=1;;
    esac
done


# Check if PostgreSQL is running and start it if not
if ! systemctl is-active --quiet postgresql; then
    echo "Starting PostgreSQL..."
    sudo systemctl start postgresql
fi


source .venv/bin/activate
if [ $init -eq 1 ]; then
    echo "Initializing PostgreSQL database..."
    ./odoo-bin --without-demo --addons-path="addons/" -d "odoo" --init=base --stop-after-init
fi

./odoo-bin --addons-path="addons/" -d "odoo" --no-database-list
