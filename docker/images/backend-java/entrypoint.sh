#!/bin/bash

echo "starting jar file"
java -version
java -jar ${BACKEND_BIN_DIR}/backend.jar &> ${BACKEND_LOG_DIR}/digitalpanda-backend.log



