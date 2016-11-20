#!/bin/bash
# Infrastructure scripts global constants and shared functions
# Author: Joël Vallone, joel.vallone@gmail.com

set -e
#set -x

#Global constants
SCRIPTS_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SERVER_CONFIG_FILE_PATH="../../services.config.csv"
DOCKER_IMAGE_FOLDER="../images"
DOCKER_REGISTRY_IP=""
DOCKER_REGISTRY_PORT=""


#Global functions
function errorMessage(){
    echo -e "$1" >&2
    exit 1
}

function sshRun(){
    sshPort=$1
    sshIp=$2
    cmd=$3
    echo -e "\t SSH-RUN -p ${sshPort} ${sshIp} : " "\n\t-> ${cmd}"
    #ssh -p ${sshPort} ${sshIp} "${cmd}" < /dev/null
}

#Install docker on the local machine
# -> requires root privileges
function installDockerUbuntu(){
    local version=$1
    sudo apt-get update
    sudo apt-get install -Y apt-transport-https ca-certificates
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo echo "deb https://apt.dockerproject.org/repo ubuntu-${version} main" | sudo tee "/etc/apt/sources.list.d/docker.list" > /dev/null
    sudo apt-get update
    sudo apt-get purge -Y lxc-docker
    sudo apt-get install -Y linux-image-extra-$(uname -r) docker-engine      
}

#Ask for docker installation
function installDockerDialog(){
    local version 
    echo "Docker installation guide: "
    echo -e "> Which version of ubuntu do you use ? \n \
\t 1 - Ubuntu Trusty 14.04 (LTS) \n \
\t q - Abort installation "
    read version
    case ${version} in 
	1)
	    installDockerUbuntu "trusty"
	    ;;
	q)
	    echo "Aborting installation"
	    exit 0
	    ;;
	*)
	    echo "ERROR: No docker installation rountine for your selection" 1>&2
	    exit 1
	    ;;
     esac
}


#Environment check
#if ! type docker &> /dev/null ; then
#    echo "This script require docker..."
#    installDockerDialog
#fi
