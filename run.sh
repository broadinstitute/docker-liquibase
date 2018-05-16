#!/bin/bash
# get progname

# /opt/liquibase/liquibase --driver=com.mysql.jdbc.Driver --classpath=/opt/liquibase/mysql-connector-java-5.1.40-bin.jar  --changeLogFile=db/cloud_metrics/liquibase/changesets/baseline.xml --url="jdbc:mysql://127.0.0.1:3306/metrics" --username=jcarey --password=test  migrate

# this script will run a changeset manually

# changesets & migration files should be loaded to the working directory /working (or a custom working dir)
# and should retain any relative directory structure

# script 

# todo check that environment vars are set

# The liquibase action (i.e. update, migrate) should come in as the first parameter of this script
ACTION=${1:-""}

DB_NAME=${DB_NAME:-""}
DB_HOST=${DB_HOST:-""}
DB_USER=${DB_USER:-""}
DB_PASSWORD=${DB_PASSWORD:-""}
WORKING_DIR=${WORKING_DIR:-"/working"}
CHGLOG_FILE=${CHGLOG_FILE:-"changelog.xml"}
CHGSETS_DIR=${CHGSETS_DIR:-"/changelog"}
LOG_DIR=${LOG_DIR:-"/working"}
LOG_LEVEL=${LOG_LEVEL:-"debug"}
LOG_OPTS=${LOG_OPTS:-""}
USE_SSL=${USE_SSL:-0}
JAVA_OPTS=${JAVA_OPTS:-""}
LIQUIBASE_OPTS=${LIQUIBASE_OPTS:-""}
SLEEP=${SLEEP:-0}

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
fi

cd ${CHGSETS_DIR}

if [ -z "${ACTION}" ]; then
    echo "Liquibase action not provided."
    exit 1
else
    echo "Running liquibase using the following command: (password hidden)"
    echo "JAVAOPTS: ${JAVA_OPTS}"
    echo "liquibase  --driver=com.mysql.jdbc.Driver ${LIQUIBASE_OPTS} ${LOG_OPTS} --changeLogFile=${CHGLOG_FILE} --url="${DB_URL}" --username=${DB_USER} --password=XXXXXXX  ${ACTION}"

    # need to add validation that changelog.xml exists
    echo "Sleeping for $SLEEP seconds..."
    sleep $SLEEP
    liquibase  --driver=com.mysql.jdbc.Driver ${LIQUIBASE_OPTS} ${LOG_OPTS} --changeLogFile=${CHGLOG_FILE} --url="${DB_URL}" --username=${DB_USER} --password=${DB_PASSWORD}  ${ACTION}
fi
