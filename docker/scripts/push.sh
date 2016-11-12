#!/bin/bash
# Push a docker image to the local docker registry
# Author: Joël Vallone, joel.vallone@gmail.com

source common.sh

#Local constants
SCRIPT_NAME=$0


#local functions
function printUsage() {
    errorMessage  "USAGE: $SCRIPT_NAME {space separated container names OR \"all\"}"
}

function pushToRegistry() {
    local imageName=$1
    local imageFullPath="${DOCKER_IMAGE_FOLDER}/${imageName}"
    echo "Build and push docker image \"${imageName}\" to docker registry ${DOCKER_REGISTRY_IP}:${DOCKER_REGISTRY_PORT}"
    sudo docker build -t ${imageName}:latest ${imageFullPath}
    sudo docker push ${DOCKER_REGISTRY_IP}:${DOCKER_REGISTRY_PORT}/${imageName}
}

#fetch and check input
if [ $# -lt 1 ]; then
    printUsage
fi

for dockerImageName in $@; do
    dockerImagePath="${DOCKER_IMAGE_FOLDER}/${dockerImageName}"
    allStr=$(echo ${dockerImageName} | awk '{print toupper($0)}')
    if [ -d  "${dockerImagePath}" ]; then
	pushToRegistry ${dockerImageName} "${dockerImagePath}"
    elif [  ${allStr} = "ALL" ]; then
	dockerImagesName="$(ls ${DOCKER_IMAGE_FOLDER})"
	echo "push all images in ${DOCKER_IMAGE_FOLDER}"
	for dockerImageName in ${dockerImagesName}; do
	    dockerImagePath="${DOCKER_IMAGE_FOLDER}/${dockerImageName}"
	    pushToRegistry ${dockerImageName} "${dockerImagePath}"
	done
	break
    else
	errorMessage "The docker image to push \"${dockerImageName}\" is not present in ${DOCKER_IMAGE_FOLDER}"
    fi;
done


    
