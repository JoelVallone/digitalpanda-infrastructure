#!/bin/bash

mkdir -p ${SHARE_FOLDER}/npm/logs

echo "starting npm server"
cd /opt/digitalpanda-frontend
npm run start &> ${SHARE_FOLDER}/npm/logs/stdout.log;
