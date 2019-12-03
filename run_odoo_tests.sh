#!/bin/bash

set +e

green() {
  echo -e "\\e[32m${1}\\e[0m"
}

red() {
  echo -e "\\e[31m${1}\\e[0m"
}

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

cd "$MODULES_PATH" || exit
echo 
MODULES=$(find ./* -maxdepth 0 -type d -print0 -and -not -path \*/.\* | xargs -0 echo | sed s'/ /,/g' | sed s'/\.\///g')
export MODULES=$MODULES
echo "-------------------------------------------"
echo "Modules to test :"
green "$MODULES"
echo
if [ -z "$MODULES" ]
then
	red "Modules list is empty"
	exit 1
fi


green " odoo -d $DATABASE ..........."
echo
/wait-for-it.sh $DB_HOST:$DATABASE_PORT -t 10 -- 
odoo -d "$DATABASE" --addons-path . -i "$MODULES" --db_host "$DB_HOST" -r "$DB_USER" -w "$DB_PASSWORD" --log-level info --stop-after-init --save -c /etc/odoo/odoo.conf


green "python3 -m pytest ..........."
echo
python3 -m pytest -s --odoo-database="$DATABASE" --odoo-log-level=debug --junitxml=./.test-reports/junit.xml --odoo-config=/etc/odoo/odoo.conf --cov-fail-under=$COV_FAIL_UNDER --cov .

exit $?


