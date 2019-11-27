# odoo-12-pytest
> Docker image to run pytest on modules directory
odoo pytest



## How to use
### Bitbucket pipeline
> Add host to container 
How to connect to postgresql from container : https://community.atlassian.com/t5/Bitbucket-Pipelines-questions/Pipelines-How-to-connect-to-a-Postgres-service-from-within/qaq-p/1096240

```shell
$ docker pull jc1204/odoo-12-pytest:latest
$ docker run -u root --volume $BITBUCKET_CLONE_DIR:/mnt/odoo/addons --env MODULES_PATH="/mnt/odoo/addons" --add-host host.docker.internal:$BITBUCKET_DOCKER_HOST_INTERNAL --env DB_HOST="host.docker.internal" --env DB_USER="odoo" --env DB_PASSWORD="odoo" --env DATABASE="odoo" --env COV_FAIL_UNDER=$Cov_Fail_Under jc1204/odoo-12-pytest:latest /run_odoo_tests.sh
```
### Travis ci
> Set network = host
```shell
$ docker pull jc1204/odoo-12-pytest:latest
$ docker run -ti  --rm -u root --volume $TRAVIS_BUILD_DIR:/mnt/odoo/addons --env MODULES_PATH="/mnt/odoo/addons" --env DB_HOST=$DB_HOST --env DB_USER=$DB_USER --env DB_PASSWORD=$DB_PASSWORD --env DATABASE=$DATABASE --env COV_FAIL_UNDER=$COV_FAIL_UNDER --network=host $IMG /run_odoo_tests.sh
```

### VARS
 - $MODULES_PATH : Directory where modules to check are stored (default /mnt/odoo/addons)
 - $DB_HOST : postgres host (default: localhost)
 - $DATABASE_PORT: default 5432 
 - $DB_USER : postgres user (default: odoo)
 - $DB_PASSWORD : postgres password (default: odoo)
 - $DATABASE : database name (default: odoo)
 - $COV_FAIL_UNDER : pytest parameter (default: 95)

