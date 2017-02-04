#!/bin/bash

echo "starting jar file"
java -version
mkdir ${SHARE_FOLDER}/java/logs
java -jar /opt/backend.jar &> ${SHARE_FOLDER}/java/logs/digitalpanda-backend.log



