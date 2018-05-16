#!/bin/bash

# Docker Hub container name
REPO="broadinstitute/liquibase"

# pull tags
git pull --tags

# GIT info
GIT_COMMIT=$(git rev-parse HEAD)
GIT_HASH=$(git rev-parse --short HEAD)
# find all tags that match git commit hash
GIT_TAGS=$(git show-ref --tags -d | grep -E "^${GIT_COMMIT}" | awk '{ print $2 }' | sed -e 's;refs/tags/;;')
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# timestamp
BUILD_DATE=$(date +%Y%m%d_%H%M%S)

# add some additional labels to docker image
echo "LABEL GIT_COMMIT=\"${GIT_COMMIT}\"" >> Dockerfile
echo "LABEL GIT_BRANCH=\"${GIT_BRANCH}\"" >> Dockerfile
echo "LABEL BUILD_DATE=\"${BUILD_DATE}\"" >> Dockerfile

# build docker
echo docker build -t ${REPO}:${GIT_HASH} .
# need to check return status on build

docker push ${REPO}:${GIT_HASH}
# need to check return status on build

for addt_tags in ${GIT_TAGS} 
do
    echo docker tag ${REPO}:${GIT_HASH} ${REPO}:${addt_tags}
    echo docker push ${REPO}:${addt_tags}
    echo docker rmi ${REPO}:${addt_tags}
done

# tag based on branch if not master
if [ "${GIT_BRANCH}" != "master" ]
then
    echo docker tag ${REPO}:${GIT_HASH} ${REPO}:${GIT_BRANCH}
    echo docker push ${REPO}:${GIT_BRANCH}
    echo docker rmi ${REPO}:${GIT_BRANCH}
fi

echo docker rmi ${REPO}:${GIT_HASH}

   


