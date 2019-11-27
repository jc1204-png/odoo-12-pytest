#!/bin/sh

set +e

# $MODULES_PATH
# $DB_HOST
# $DB_USER
# $DB_PASSWORD
# $COV_FAIL_UNDER
# $DATABASE

# TESTS vars or set default

cd "$MODULES_PATH"
echo 
export MODULES=$(ls -md */ | sed 's/\///g' | sed 's/, /,/g' | sed -z 's/\n//g')
echo "-------------------------------------------"
echo "Modules to test :"
echo "$MODULES"
echo


echo " odoo -d $DATABASE ..........."
echo
odoo -d "$DATABASE" --addons-path . -i "$MODULES" --db_host "$DB_HOST" -r "$DB_USER" -w $DB_PASSWORD --log-level info --stop-after-init --save -c /etc/odoo/odoo.conf

echo "python3 -m pytest ..........."
echo
python3 -m pytest -s --odoo-database="$DATABASE" --odoo-log-level=debug --junitxml=./.test-reports/junit.xml --odoo-config=/etc/odoo/odoo.conf --cov-fail-under=$COV_FAIL_UNDER --cov .

exit $?


