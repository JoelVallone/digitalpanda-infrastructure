#!/bin/bash

mkdir -p ${SHARE_FOLDER}/http-server/logs

echo "starting npm server"
http-server -a 0.0.0.0 -p 8000 /opt/digitalpanda-frontend &> ${SHARE_FOLDER}/http-server/logs/digitalpanda-frontend.log
