#!/bin/bash

# this script will construct the Dockerfile for this build based on 
# the values for these environment vars:
#  - JDK_VERSION
#  - VAULT_VERSION
#  - LIQUIBASE_VERSION
#  - MYSQL-CONN_VERSION

# If any of these environment vars are not set the build will exit with failure
JDK_VERSION=${JDK_VERSION:-"8"}
VAULT_VERSION=${VAULT_VERSION:-"0.7.0"}
LIQUIBASE_VERSION=${LIQUIBASE_VERSION:-"3.5.3"}
MYSQL-CONN_VERSION=${MYSQL-CONN_VERSION:-"5.1.40"}

# the Dockerfile template is required to exist in this repo

# Docker Hub container name
REPO="broadinstitute/liquibase"

# build number hack
BUILD_NUM=${BUILD_NUM:-0}
BUILD_TAG=${BUILD_TAG:-"build"}

# TODO
# check that all vars are set

if [ -z "${JDK_VERSION}" -o -z "${VAULT_VERSION}" -o -z "${LIQUIBASE_VERSION}" -o -z "${MYSQLCONN_VERSION}" ]
then
    echo "ERROR: Must specify versions that will be part of build"
    exit 1
fi

# build Dockerfile from template

sed -e "s;LIQUIBASE_VERSION_TAG;${LIQUIBASE_VERSION};" -e "s;MYSQLCONN_VERSION_TAG;${MYSQLCONN_VERSION};" -e "s;VAULT_VERSION_TAG;${VAULT_VERSION};" -e "s;JDK_VERSION_TAG;${JDK_VERSION};" < Dockerfile.tmpl > Dockerfile

# build docker

docker build -t ${REPO}:${BUILD_TAG}.${BUILD_NUM} .
# need to check return status on build

# rm Dockerfile after build
rm -f Dockerfile

docker tag ${REPO}:${BUILD_TAG}.${BUILD_NUM} ${REPO}:liquibase-${LIQUIBASE_VERSION}


