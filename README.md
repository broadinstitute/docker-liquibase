# docker-liquibase
Dockerfile and built utility for creating Liquibase utility in a docker container

BUILD:

./build-docker.sh

USAGE EXAMPLE:

ENV=dev
DB_PASSWORD=$(vault read -field=admin_password "<VAULTPATH>")
CHGLOG_DIR="/changelog/db/cloud_metrics/liquibase"

metrics.env:
APP_PROJ=gotc
APP_NAME=metrics
DB_NAME=metrics
DB_HOST=<DNS_NAME_MYSQL_INSTANCE>
DB_USER=metrics_admin

docker run -it --rm --env-file=metrics.env -e ENV=${ENV} -e CHGLOG_DIR=${CHGLOG_DIR} -e DB_PASSWORD=${DB_PASSWORD} -e VAULT_ADDR=${VAULT_ADDR} -v <PATH-TO-CHANGELOG>:/changelog -v <PATH_CHANGESETS>:/changesets -v ${PWD}:/working -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/liquibase:3.5.3 /bin/bash

run.sh
