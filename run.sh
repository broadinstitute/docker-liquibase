#!/bin/bash
# get progname

# /opt/liquibase/liquibase --driver=com.mysql.jdbc.Driver --classpath=/opt/liquibase/mysql-connector-java-5.1.40-bin.jar  --changeLogFile=db/cloud_metrics/liquibase/changesets/baseline.xml --url="jdbc:mysql://127.0.0.1:3306/metrics" --username=jcarey --password=test  migrate

# this script will run a changeset manually

# changesets should appear under the directory in the var CHGLOG_DIR
# NOTE: you need to ensure that any path referenced by the changelog.xml is 
#  resolveable inside docker.  Best practise is for changesets to be referenced
#  using relative paths

# script 

# todo check that environment vars are set

ENV=${ENV:-""}
APP_PROJ=${APP_PROJ:-""}
APP_NAME=${APP_NAME:-""}
DB_NAME=${DB_NAME:-"${APP_NAME}"}
DB_HOST=${DB_HOST:-""}
DB_USER=${DB_USER:-""}
DB_PASSWORD=${DB_PASSWORD:-""}
CHGLOG_DIR=${CHGLOG_DIR:-"/changesets"}
LOG_DIR=${LOG_DIR:-"/working"}
LOG_LEVEL=${LOG_LEVEL:-"debug"}
LOG_OPTS=${LOG_OPTS:-""}
USE_SSL=${USE_SSL:-1}
USE_RELATIVE=${USE_RELATIVE:-1}
VAULT_TOKEN_FILE=${VAULT_TOKEN_FILE:-"/root/.vault-token"}
VAULT_TOKEN=${VAULT_TOKEN:-""}
JAVA_OPTS=${JAVA_OPTS:-""}
LIQUIBASE_OPTS=${LIQUIBASE_OPTS:-""}

if [ ! -z "${LOG_LEVEL}" ]
then
   # if log level set also set logfile output
   LOG_OPTS="--logLevel=${LOG_LEVEL} --logFile=${LOG_DIR}/log.out"
fi

DB_URL="jdbc:mysql://${DB_HOST}:3306/${DB_NAME}"
# add SSL if set

if [ "${USE_SSL}" -eq 1 ]
then
  DB_URL="${DB_URL}?useSSL=true&requireSSL=true"
  vault read --field=keystore "secret/dsde/${APP_PROJ}/${ENV}/${APP_NAME}/${DB_NAME}-mysql" | base64 -d > /tmp/keystore
  vault read --field=truststore "secret/dsde/${APP_PROJ}/${ENV}/${APP_NAME}/${DB_NAME}-mysql" | base64 -d > /tmp/truststore
 JAVA_OPTS="${JAVA_OPTS} -Djavax.net.ssl.keyStore=/tmp/keystore -Djavax.net.ssl.keyStorePassword=changeit -Djavax.net.ssl.trustStore=/tmp/truststore -Djavax.net.ssl.trustStorePassword=changeit"
  export JAVA_OPTS
fi

# DB_USER=`vault read --field=admin_user "secret/dsde/${APP_PROJ}/${ENV}/${DB_NAME}/secrets"`
# DB_PASSWORD=`vault read --field=admin_password "secret/dsde/${APP_PROJ}/${ENV}/${DB_NAME}/secrets"`

echo "Running liquibase using the following command: (password hidden)"
echo "JAVAOPTS: ${JAVA_OPTS}"
echo "liquibase  --driver=com.mysql.jdbc.Driver ${LOG_OPTS} --changeLogFile=${CHGLOG_DIR}/changelog.xml --url="${DB_URL}" --username=${DB_USER} --password=XXXXXXX  migrate"

cd ${CHGLOG_DIR}
# make sure you can cd

if [ "${USE_RELATIVE}" -ne 1 ]
then
    change_path="."
else
    change_path="${CHGLOG_DIR}"
fi

# need to add validation that changelog.xml exists

liquibase  --driver=com.mysql.jdbc.Driver ${LIQUIBASE_OPTS} ${LOG_OPTS} --changeLogFile=${change_path}/changelog.xml --url="${DB_URL}" --username=${DB_USER} --password=${DB_PASSWORD}  migrate

