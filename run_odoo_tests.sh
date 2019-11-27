#!/bin/sh

set +e

# $MODULES_PATH
if [ -z "$MODULES_PATH" ] 
then
	export MODULES_PATH="/mnt/odoo/addons"
fi

# $DB_HOST
if [ -z "$DB_HOST" ] 
then 
	export DB_HOST="localhost"
fi

# $DB_PORT
if [ -z "$DATABASE_PORT" ] 
then 
	export DATABASE_PORT="5432"
fi

# $DB_USER
if [ -z "$DB_USER" ] 
then 
	export DB_USER="odoo"
fi

# $DB_PASSWORD
if [ -z "$DB_PASSWORD" ] 
then 
	export DB_PASSWORD="odoo"
fi

# $DATABASE
if [ -z "$DATABASE" ] 
then 
	export DATABASE="odoo"
fi

# $COV_FAIL_UNDER
if [ -z "$COV_FAIL_UNDER" ] 
then 
	export COV_FAIL_UNDER="95"
fi

cd "$MODULES_PATH"
echo 
export MODULES=$(ls -md */ | sed 's/\///g' | sed 's/, /,/g' | sed -z 's/\n//g')
echo "-------------------------------------------"
echo "Modules to test :"
echo "$MODULES"
echo


echo " odoo -d $DATABASE ..........."
echo
/wait-for-it.sh $DB_HOST:$DATABASE_PORT -t 10 -- 
odoo -d "$DATABASE" --addons-path . -i "$MODULES" --db_host "$DB_HOST" -r "$DB_USER" -w "$DB_PASSWORD" --log-level info --stop-after-init --save -c /etc/odoo/odoo.conf


echo "python3 -m pytest ..........."
echo
python3 -m pytest -s --odoo-database="$DATABASE" --odoo-log-level=debug --junitxml=./.test-reports/junit.xml --odoo-config=/etc/odoo/odoo.conf --cov-fail-under=$COV_FAIL_UNDER --cov .

exit $?


