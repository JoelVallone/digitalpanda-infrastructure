#!/bin/bash

mkdir ${SHARE_FOLDER}/npm/logs

echo "starting npm server"
npm run start &> ${SHARE_FOLDER}/npm/logs/stdout.log;
