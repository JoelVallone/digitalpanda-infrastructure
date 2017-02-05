#!/bin/bash
# Push a docker image to the local docker registry
# Author: Joël Vallone, joel.vallone@gmail.com

#Local constants
SCRIPT_NAME=$0
SCRIPT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INITIAL_FOLDER=$(pwd)
echo "Build & push infrastructure"
cd ${SCRIPT_FOLDER}/../digitalpanda-backend/scripts/
./build.sh
cd ${SCRIPT_FOLDER}/../digitalpanda-frontend/scripts/
./build-prod.sh
sudo ${SCRIPT_FOLDER}/docker/scripts/push.sh backend-java frontend-angular2
cd ${INITIAL_FOLDER}

echo "Restart containers"
${SCRIPT_FOLDER}/docker/scripts/deploy.sh digitalpanda-backend-0 digitalpanda-frontend-0

