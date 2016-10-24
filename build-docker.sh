#!/bin/bash

# this script will construct the Dockerfile for this build based on 
# the values for these environment vars:
#  - JDK_VERSION
#  - VAULT_VERSION
#  - LIQUIBASE_VERSION
#  - MYSQL-CONN_VERSION

# If any of these environment vars are not set the build will exit with failure

# the Dockerfile template is required to exist in this repo

# Docker Hub container name
REPO="broadinstitute/liquibase"

# TODO
# check that all vars are set


