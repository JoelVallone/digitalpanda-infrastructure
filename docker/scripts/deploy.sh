#!/bin/bash
# (Re)deploy all the docker containers
# Author: Joël Vallone, joel.vallone@gmail.com

source common.sh
#Local constants
SCRIPT_NAME=$0

#local functions
function printUsage() {
    errorMessage  "USAGE: $SCRIPT_NAME {space separated container names OR \"all\"}"
}

INSTANCE_NAME=0
DOCKER_IMAGE=1
SERVER_MODE=2
BINDING_IP=3
BINDING_PORT=4

function fetchCsvConfig(){
    srvCnt=0
    while read line ;do
	srvConfig[${srvCnt}]=${line}
	srvInstanceNameMap[${srvConfig[${INSTANCE_NAME}]}]=${srvCnt}
	((srvCnt++))
    done < ${SERVER_CONFIG_FILE_PATH}
}

function getCsvConfig(){
  if [ ! -z ${1+x} ]; then
	srvId=${srvInstanceNameMap[${1}]}
	if [ ! -z ${srvId+x} ]; then
	    echo ${srvConfig[${srvId}]}
	else
	    errorMessage "${SCRIPT_NAME}.getCsvConfig(): unknown container instance name \"${1}\", please check your server config file at ${SCRIPTS_FOLDER}/${SERVER_CONFIG_FILE_PATH}"
	fi
  else
      errorMessage "${SCRIPT_NAME}.getCsvConfig(): missing container name"
  fi
}

function stopAndRemoveContainer() {
    docker rm ${1}
    docker rmi ${1}
}

function deployContainer() {
   if [ ! -z ${1+x} ]; then
       srvConfig=(${1//,/ })
       instanceName=${srvConfig[${INSTANCE_NAME}]}
       dockerImage=${srvConfig[${DOCKER_IMAGE}]}
       if [ -z ${instanceName} -o -z ${dockerImage} ]; then
	   errorMessage "${SCRIPT_NAME}.startContainer(): malformed container csvConfig line for one of the following parameters : \
INSTANCE_NAME=\"${srvConfig[${INSTANCE_NAME}]}\" \
DOCKER_IMAGE=\"\" "
       fi
       if [ ${srvConfig[${SEVER_MODE}]} -eq 0 ]; then
	   sudo docker run \
	       -t -i \
	       --name  ${instanceName} \
	       ${dockerImage}:latest /bin/bash
       else
	   sudo docker run \
	       -p ${srvConfig[${BINDING_IP}]}:${srvConfig[${BINDING_PORT}]}:${srvConfig[${BINDING_PORT}]} \
	       -t -i \
	       --name ${srvConfig[${INSTANCE_NAME}]} \
	       ${srvConfig[${DOCKER_IMAGE}]} /bin/bash
       fi
    else
	errorMessage "${SCRIPT_NAME}.startContainer(): missing container csvConfig line"
    fi
}

function getContainerId() {
    if [ ! -z ${1+x} ];then
	docker ps -a | grep ${1} | awk '{print $7}'
    else
	errorMessage "${SCRIPT_NAME}.getContainerId(): missing container instance name"
    fi
}

#fetch and check input
if [ $# -lt 1 ]; then
    printUsage
fi

#fetch containers deployment config
fetchCsvConfig

for dockerInstanceName in $@; do
    #remove containers before deploy if any
    if [ ${dockerInstanceName,,} = "all" ]; then
	containerIds=(docker ps -qa)
    else
	containerIds=$(getContainerId ${dockerInstanceName})
    fi    
    if [ ! -z ${containerId+x} ];then
	stopAndRemoveContainer ${containerId}
    fi

    #deploy container
    if [ ${dockerInstanceName,,} = "all" ];then
	for srvId:= 0 to ((srvCnt-1))
	do
	    deployContainer ${srvConfig[${srvId}]}
	done
	exit 0;
    else
       instanceCsvConfig=$(getContainerCsvConfig ${dockerInstanceName})
       deployContainer ${instanceCsvConfig}
    fi
done
