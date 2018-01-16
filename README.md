# docker-liquibase
Dockerfile and built utility for creating Liquibase utility in a docker container

## Build
```
./build-docker.sh
```

## Run

environment:
```
ENV=dev
DB_PASSWORD=$(vault read -field=admin_password "<VAULTPATH>")
CHGLOG_DIR="/changelog/db/cloud_metrics/liquibase"
```

example metrics.env file:
```
APP_PROJ=gotc
APP_NAME=metrics
DB_NAME=metrics
DB_HOST=<DNS_NAME_MYSQL_INSTANCE>
DB_USER=metrics_admin
```

```
docker run --rm --env-file=metrics.env \
    -v <PATH-TO-CHANGELOG/SETS>:/working \
    -e CHGLOG_FILE:/working/custom-changelog.xml \
	-e ENV=${ENV} \
	-e CHGLOG_DIR=${CHGLOG_DIR} \
	-e DB_PASSWORD=${DB_PASSWORD} \
	-e VAULT_ADDR=${VAULT_ADDR} \
	-v ${PWD}:/working \
	-v ${HOME}/.vault-token:/root/.vault-token \
	broadinstitute/liquibase:3.5.3 run.sh upgrade
```
